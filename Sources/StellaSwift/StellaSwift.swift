// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Antlr4
#if os(Linux)
import Glibc
#elseif os(Windows)
import CRT
#else
import Darwin
#endif

@main
struct StellaSwift {
    static func main() {
        // Checking command line arguments
        let arguments = CommandLine.arguments
        
        // If run with the --help argument, display help information
        if arguments.contains("--help") || arguments.contains("-h") {
            printHelp()
            exit(0)
        }
        
        // Checking flags
        let showParseTree = arguments.contains("--parse-tree")
        let showAST = arguments.contains("--ast")
        let showSource = arguments.contains("--source")
        
        // Find the path to the file (the first argument that does not start with -)
        let filePath = arguments.dropFirst().first { !$0.starts(with: "-") }
        
        var code = ""
        
        // Check if there is an argument with the file
        if let path = filePath {
            // Reading from a file
            do {
                code = try String(contentsOfFile: path, encoding: .utf8)
            } catch {
                var errStream = StandardErrorOutputStream()
                print("Error reading file '\(path)': \(error)", to: &errStream)
                exit(1)
            }
        } else {
            // Check if there is piped input (not terminal)
            #if os(Windows)
            let isInputFromTerminal = _isatty(STDIN_FILENO) != 0
            #else
            let isInputFromTerminal = isatty(STDIN_FILENO) == 1
            #endif
            
            if !isInputFromTerminal {
                // Reading from stdin (pipe or redirect)
                while let line = readLine(strippingNewline: false) {
                    code += line
                }
            }
            
            // If the input data is empty, we use the test example
            if code.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                code = getTestProgram()
                var errStream = StandardErrorOutputStream()
                print("// Using test program (no input provided):", to: &errStream)
            }
        }
        
        // Optionally print original Stella source before any analysis
        if showSource {
            print("=== Source Code ===")
            print(code.trimmingCharacters(in: .whitespacesAndNewlines))
            print("")
        }
        
        do {
            // 1. If a parse tree is needed, we show it
            if showParseTree {
                let input = ANTLRInputStream(code)
                let lexer = stellaLexer(input)
                let tokens = CommonTokenStream(lexer)
                let parser = try stellaParser(tokens)
                parser.setBuildParseTree(true)
                let tree = try parser.start_Program()
                
                print("=== Parse Tree ===")
                let treeStr = Trees.toStringTree(tree, parser)
                print(treeStr)
                print("")
            }
            
            // 2. We parse the program and build an AST
            let program = try buildAST(from: code)
            
            // 3. If an AST is needed, we'll show it
            if showAST {
                print("=== Abstract Syntax Tree ===")
                print("Language: \(program.languageDecl)")
                if !program.extensions.isEmpty {
                    print("Extensions:")
                    for ext in program.extensions {
                        print("  - \(ext.names.joined(separator: ", "))")
                    }
                }
                print("\nDeclarations:")
                for (index, decl) in program.decls.enumerated() {
                    printDecl(decl, indent: 0, index: index + 1)
                }
                print("")
            }
            
            // 4. Performing type checking
            let typeChecker = TypeChecker()
            try typeChecker.typecheck(program: program)
            
            // Successful type checking
            print("Type checking successful!")
            exit(0)
            
        } catch let error as TypeCheckError {
            // Output the typing error to stderr
            var errStream = StandardErrorOutputStream()
            print(error.description, to: &errStream)
            exit(1)
            
        } catch {
            // Other errors (parsing, etc.)
            var errStream = StandardErrorOutputStream()
            print("Error: \(error)", to: &errStream)
            exit(1)
        }
    }
    
    static func printHelp() {
        print("""
        Stella Type Checker
        
        Usage:
            swift run StellaSwift [options] [file]
            swift run StellaSwift < input.stella
            echo "language core; fn main(n : Nat) -> Nat { return n }" | swift run StellaSwift
        
        Options:
            -h, --help          Show this help message
            --parse-tree        Show ANTLR parse tree before type checking
            --ast               Show Abstract Syntax Tree before type checking
            --source            Show original Stella source code before analysis
        
        Arguments:
            file                Input file (if not provided, reads from stdin)
        
        Description:
            Type checker for the Stella programming language.
            Reads a Stella program from stdin or file and performs type checking.
            
        Exit codes:
            0 - Type checking successful
            1 - Type checking failed (error printed to stderr)
        
        Examples:
            # 1. Build
            swift build
        
            # 2. Simple run
            swift run StellaSwift examples/01_simple.stella
        
            # 3. With AST
            swift run StellaSwift --ast examples/03_with_tuples.stella
        
            # 4. With parse tree
            swift run StellaSwift --parse-tree examples/04_with_records.stella
            
            # 5. With source code
            swift run StellaSwift --source examples/01_simple.stella
        
            # 6. All debug flags
            swift run StellaSwift --source --parse-tree --ast examples/03_with_tuples.stella

            # 7. Running default test program
            swift run StellaSwift
        """)
    }
    
    static func getTestProgram() -> String {
        return """
        language core;
        
        extend with #unit-type, #tuples, #records, #lists, #sum-types, #fixpoint-combinator;
        
        fn increment_twice(n : Nat) -> Nat {
            return succ(succ(n))
        }
        
        fn test_if(n : Nat) -> Bool {
            return if Nat::iszero(n) then true else false
        }
        
        fn test_tuple(n : Nat) -> {Nat, Bool, Unit} {
            return {n, true, unit}
        }
        
        fn test_record(n : Nat) -> {x : Nat, y : Bool} {
            return {x = n, y = false}
        }
        
        fn main(n : Nat) -> Nat {
            return increment_twice(n)
        }
        """
    }
}

// MARK: - AST Pretty Printing

extension StellaSwift {
    static func printDecl(_ decl: Decl, indent: Int, index: Int) {
        let indentStr = String(repeating: "  ", count: indent)
        
        switch decl {
        case .declFun(let name, let params, let returnType, let localDecls, let returnExpr, _):
            print("\(indentStr)\(index). Function '\(name)'")
            print("\(indentStr)   Parameters:")
            for (i, param) in params.enumerated() {
                print("\(indentStr)     \(i + 1). \(param.name) : \(param.paramType)")
            }
            if let retType = returnType {
                print("\(indentStr)   Return type: \(retType)")
            }
            if !localDecls.isEmpty {
                print("\(indentStr)   Local declarations:")
                for (i, localDecl) in localDecls.enumerated() {
                    printDecl(localDecl, indent: indent + 2, index: i + 1)
                }
            }
            print("\(indentStr)   Body: \(summarizeExpr(returnExpr))")
        }
    }
    
    static func summarizeExpr(_ expr: Expr) -> String {
        switch expr {
        case .constTrue: return "true"
        case .constFalse: return "false"
        case .constInt(let n, _): return "\(n)"
        case .constUnit: return "unit"
        case .variable(let name, _): return "var(\(name))"
        case .abstraction(let params, _, _):
            let paramStr = params.map { "\($0.name):\($0.paramType)" }.joined(separator: ", ")
            return "λ(\(paramStr))"
        case .application(let fun, let args, _):
            return "\(summarizeExpr(fun))(\(args.count) args)"
        case .ifExpr:
            return "if-then-else"
        case .succ(let n, _):
            return "succ(\(summarizeExpr(n)))"
        case .natRec:
            return "Nat::rec(...)"
        case .isZero:
            return "Nat::iszero(...)"
        case .pred:
            return "Nat::pred(...)"
        case .letExpr(let bindings, _, _):
            return "let (\(bindings.count) bindings)"
        case .letRec(let bindings, _, _):
            return "letrec (\(bindings.count) bindings)"
        case .typeAsc(_, let type, _):
            return "(_ as \(type))"
        case .tuple(let exprs, _):
            return "{\(exprs.count) elements}"
        case .dotTuple(_, let index, _):
            return ".tuple[\(index)]"
        case .record(let bindings, _):
            return "{\(bindings.map { $0.name }.joined(separator: ", "))}"
        case .dotRecord(_, let label, _):
            return ".\(label)"
        case .inl:
            return "inl(...)"
        case .inr:
            return "inr(...)"
        case .match(_, let cases, _):
            return "match (\(cases.count) cases)"
        case .list(let exprs, _):
            return "[\(exprs.count) elements]"
        case .consList:
            return "cons(...)"
        case .head:
            return "List::head(...)"
        case .tail:
            return "List::tail(...)"
        case .isEmpty:
            return "List::isempty(...)"
        case .variant(let label, _, _):
            return "<|\(label)|>"
        case .fix:
            return "fix(...)"
        case .add, .subtract, .multiply, .divide:
            return "arithmetic op"
        case .logicNot, .logicAnd, .logicOr:
            return "logic op"
        case .lessThan, .lessThanOrEqual, .greaterThan, .greaterThanOrEqual, .equal, .notEqual:
            return "comparison op"
        case .sequence:
            return "sequence"
        case .parenthesised(let inner, _):
            return "(\(summarizeExpr(inner)))"
        }
    }
}

// Helper for writing into stderr
struct StandardErrorOutputStream: TextOutputStream {
    func write(_ string: String) {
        FileHandle.standardError.write(Data(string.utf8))
    }
}
