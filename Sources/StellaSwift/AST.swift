// AST.swift
// Abstract Syntax Tree for Stella language

import Foundation

// MARK: - Source Position (for pretty error messages)

struct SourcePosition: Sendable {
    let line: Int
    let column: Int
    
    static let unknown = SourcePosition(line: 0, column: 0)
}

// MARK: - Program Structure

struct Program: Sendable {
    let languageDecl: LanguageDecl  // "language core;"
    let extensions: [Extension]  // "extend with #unit-type, ..."
    let decls: [Decl]  // all functions
}

enum LanguageDecl: Sendable {
    case core
}

struct Extension: Sendable {
    let names: [String]
}

// MARK: - Declarations

enum Decl: Sendable {
    case declFun(
        name: String,
        paramDecls: [ParamDecl],
        returnType: Type?,
        localDecls: [Decl],
        returnExpr: Expr,
        position: SourcePosition
    )
}

struct ParamDecl: Sendable { // represents a function parameter (`n : Nat`)
    let name: String
    let paramType: Type
    let position: SourcePosition
}

// MARK: - Types

indirect enum Type: Sendable {
    case bool                                              // Bool
    case nat                                               // Nat
    case unit                                              // Unit
    case function(paramTypes: [Type], returnType: Type)    // fn(T1, T2) -> T3
    case tuple([Type])                                     // {T1, T2, T3}
    case record([RecordFieldType])                         // {x: T1, y: T2}
    case sum(left: Type, right: Type)                      // T1 + T2
    case list(Type)                                        // [T]
    case variant([VariantFieldType])                       // <|l1: T1, l2: T2|>
    
    var position: SourcePosition {
        return .unknown // can be expanded for storage of items
    }
}

struct RecordFieldType: Sendable { // Used in: {x : Nat, y : Bool}
    let label: String // Field name
    let fieldType: Type // Field type
}

struct VariantFieldType: Sendable { // Used in: <|left : Nat, right : Bool|>/
    let label: String
    let fieldType: Type?  // Tyoe (none for nullary labels)
}

// MARK: - Expressions

indirect enum Expr: Sendable {
    // Literals
    case constTrue(SourcePosition)
    case constFalse(SourcePosition)
    case constInt(Int, SourcePosition)
    case constUnit(SourcePosition)
    
    // Variables
    case variable(String, SourcePosition)
    
    // Functions
    case abstraction(paramDecls: [ParamDecl], returnExpr: Expr, SourcePosition)
    case application(fun: Expr, args: [Expr], SourcePosition)
    
    // Conditionals
    case ifExpr(condition: Expr, thenExpr: Expr, elseExpr: Expr, SourcePosition)
    
    // Natural numbers
    case succ(Expr, SourcePosition)
    case natRec(n: Expr, initial: Expr, step: Expr, SourcePosition)
    case isZero(Expr, SourcePosition)
    case pred(Expr, SourcePosition)
    
    // Let bindings
    case letExpr(bindings: [PatternBinding], body: Expr, SourcePosition)
    case letRec(bindings: [PatternBinding], body: Expr, SourcePosition)
    
    // Type ascription
    case typeAsc(expr: Expr, type: Type, SourcePosition)
    
    // Tuples
    case tuple([Expr], SourcePosition)
    case dotTuple(expr: Expr, index: Int, SourcePosition)
    
    // Records
    case record([Binding], SourcePosition)
    case dotRecord(expr: Expr, label: String, SourcePosition)
    
    // Sum types
    case inl(Expr, SourcePosition)
    case inr(Expr, SourcePosition)
    case match(expr: Expr, cases: [MatchCase], SourcePosition)
    
    // Lists
    case list([Expr], SourcePosition)
    case consList(head: Expr, tail: Expr, SourcePosition)
    case head(Expr, SourcePosition)
    case tail(Expr, SourcePosition)
    case isEmpty(Expr, SourcePosition)
    
    // Variants
    case variant(label: String, expr: Expr?, SourcePosition)
    
    // Fixpoint
    case fix(Expr, SourcePosition)
    
    // Arithmetic operators (if needed for extensions)
    case add(left: Expr, right: Expr, SourcePosition)
    case subtract(left: Expr, right: Expr, SourcePosition)
    case multiply(left: Expr, right: Expr, SourcePosition)
    case divide(left: Expr, right: Expr, SourcePosition)
    
    // Logic operators
    case logicNot(Expr, SourcePosition)
    case logicAnd(left: Expr, right: Expr, SourcePosition)
    case logicOr(left: Expr, right: Expr, SourcePosition)
    
    // Comparison operators
    case lessThan(left: Expr, right: Expr, SourcePosition)
    case lessThanOrEqual(left: Expr, right: Expr, SourcePosition)
    case greaterThan(left: Expr, right: Expr, SourcePosition)
    case greaterThanOrEqual(left: Expr, right: Expr, SourcePosition)
    case equal(left: Expr, right: Expr, SourcePosition)
    case notEqual(left: Expr, right: Expr, SourcePosition)
    
    // Sequencing
    case sequence(expr1: Expr, expr2: Expr, SourcePosition)
    
    // Parenthesised
    case parenthesised(Expr, SourcePosition)
    
    var position: SourcePosition {
        switch self {
        case .constTrue(let pos), .constFalse(let pos), .constInt(_, let pos), .constUnit(let pos),
             .variable(_, let pos), .abstraction(_, _, let pos), .application(_, _, let pos),
             .ifExpr(_, _, _, let pos), .succ(_, let pos), .natRec(_, _, _, let pos),
             .isZero(_, let pos), .pred(_, let pos), .letExpr(_, _, let pos), .letRec(_, _, let pos),
             .typeAsc(_, _, let pos), .tuple(_, let pos), .dotTuple(_, _, let pos),
             .record(_, let pos), .dotRecord(_, _, let pos), .inl(_, let pos), .inr(_, let pos),
             .match(_, _, let pos), .list(_, let pos), .consList(_, _, let pos),
             .head(_, let pos), .tail(_, let pos), .isEmpty(_, let pos),
             .variant(_, _, let pos), .fix(_, let pos),
             .add(_, _, let pos), .subtract(_, _, let pos), .multiply(_, _, let pos), .divide(_, _, let pos),
             .logicNot(_, let pos), .logicAnd(_, _, let pos), .logicOr(_, _, let pos),
             .lessThan(_, _, let pos), .lessThanOrEqual(_, _, let pos),
             .greaterThan(_, _, let pos), .greaterThanOrEqual(_, _, let pos),
             .equal(_, _, let pos), .notEqual(_, _, let pos),
             .sequence(_, _, let pos), .parenthesised(_, let pos):
            return pos
        }
    }
}

// MARK: - Patterns

indirect enum Pattern: Sendable { // Patterns for pattern matching
    case patternVar(String, SourcePosition)
    case patternInt(Int, SourcePosition)
    case patternSucc(Pattern, SourcePosition)
    case patternTrue(SourcePosition)
    case patternFalse(SourcePosition)
    case patternUnit(SourcePosition)
    case patternInl(Pattern, SourcePosition)
    case patternInr(Pattern, SourcePosition)
    case patternTuple([Pattern], SourcePosition)
    case patternRecord([LabelledPattern], SourcePosition)
    case patternList([Pattern], SourcePosition)
    case patternCons(head: Pattern, tail: Pattern, SourcePosition)
    case patternVariant(label: String, pattern: Pattern?, SourcePosition)
    case patternAsc(pattern: Pattern, type: Type, SourcePosition)
    
    var position: SourcePosition {
        switch self {
        case .patternVar(_, let pos), .patternInt(_, let pos), .patternSucc(_, let pos),
             .patternTrue(let pos), .patternFalse(let pos), .patternUnit(let pos),
             .patternInl(_, let pos), .patternInr(_, let pos), .patternTuple(_, let pos),
             .patternRecord(_, let pos), .patternList(_, let pos), .patternCons(_, _, let pos),
             .patternVariant(_, _, let pos), .patternAsc(_, _, let pos):
            return pos
        }
    }
}

struct LabelledPattern: Sendable {
    let label: String
    let pattern: Pattern
}

struct PatternBinding: Sendable { // Used in: let x = expr
    let pattern: Pattern // To the left of =
    let rhs: Expr // To the right of =
}

// MARK: - Match Cases

struct MatchCase: Sendable { // Used in: match { inl(x) => expr1 | inr(y) => expr2 }
    let pattern: Pattern // inl(x) => ...
    let expr: Expr // ... => expr
}

// MARK: - Bindings (for records)

struct Binding: Sendable { // Used in: {x = expr1, y = expr2}
    let name: String // Field name
    let rhs: Expr // Value
}

// MARK: - Helper Extensions

extension Expr: CustomStringConvertible {
    var description: String {
        switch self {
        case .constTrue: return "true"
        case .constFalse: return "false"
        case .constInt(let n, _): return "\(n)"
        case .constUnit: return "unit"
        case .variable(let name, _): return name
        case .abstraction(let params, let body, _):
            let paramStr = params.map { "\($0.name) : \($0.paramType)" }.joined(separator: ", ")
            return "fn(\(paramStr)) { return \(body) }"
        case .application(let fun, let args, _):
            let argsStr = args.map { "\($0)" }.joined(separator: ", ")
            return "\(fun)(\(argsStr))"
        case .ifExpr(let cond, let then, let else_, _):
            return "if \(cond) then \(then) else \(else_)"
        default:
            return "Expr(...)"
        }
    }
}

extension Type: CustomStringConvertible {
    var description: String {
        switch self {
        case .bool: return "Bool"
        case .nat: return "Nat"
        case .unit: return "Unit"
        case .function(let params, let ret):
            let paramStr = params.map { "\($0)" }.joined(separator: ", ")
            return "fn(\(paramStr)) -> \(ret)"
        case .tuple(let types):
            let typesStr = types.map { "\($0)" }.joined(separator: ", ")
            return "{\(typesStr)}"
        case .record(let fields):
            let fieldsStr = fields.map { "\($0.label) : \($0.fieldType)" }.joined(separator: ", ")
            return "{\(fieldsStr)}"
        case .sum(let left, let right):
            return "\(left) + \(right)"
        case .list(let elemType):
            return "[\(elemType)]"
        case .variant(let fields):
            let fieldsStr = fields.map { field in
                if let type = field.fieldType {
                    return "\(field.label) : \(type)"
                } else {
                    return field.label
                }
            }.joined(separator: ", ")
            return "<|\(fieldsStr)|>"
        }
    }
}

extension Type: Equatable {
    static func == (lhs: Type, rhs: Type) -> Bool {
        switch (lhs, rhs) {
        case (.bool, .bool), (.nat, .nat), (.unit, .unit):
            return true
        case (.function(let p1, let r1), .function(let p2, let r2)):
            return p1 == p2 && r1 == r2
        case (.tuple(let t1), .tuple(let t2)):
            return t1 == t2
        case (.record(let f1), .record(let f2)):
            guard f1.count == f2.count else { return false }
            for (field1, field2) in zip(f1, f2) {
                if field1.label != field2.label || field1.fieldType != field2.fieldType {
                    return false
                }
            }
            return true
        case (.sum(let l1, let r1), .sum(let l2, let r2)):
            return l1 == l2 && r1 == r2
        case (.list(let t1), .list(let t2)):
            return t1 == t2
        case (.variant(let f1), .variant(let f2)):
            guard f1.count == f2.count else { return false }
            for (field1, field2) in zip(f1, f2) {
                if field1.label != field2.label || field1.fieldType != field2.fieldType {
                    return false
                }
            }
            return true
        default:
            return false
        }
    }
}
