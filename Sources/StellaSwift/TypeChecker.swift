// TypeChecker.swift
// Type checker for Stella language

import Foundation

// MARK: - Type Checking Errors

enum TypeCheckError: Error, CustomStringConvertible {
    case errorMissingMain
    case errorIncorrectTypeOfMain
    case errorUndefinedVariable(name: String, position: SourcePosition)
    case errorIllegalNegativeLiteral(position: SourcePosition)
    case errorUnexpectedTypeForExpression(expected: Type, found: Type, expr: Expr)
    case errorNotAFunction(expr: Expr, actualType: Type)
    case errorNotATuple(expr: Expr, actualType: Type)
    case errorNotARecord(expr: Expr, actualType: Type)
    case errorNotAList(expr: Expr, actualType: Type)
    case errorUnexpectedLambda(expected: Type, position: SourcePosition)
    case errorUnexpectedTypeForParameter(expected: Type, found: Type, position: SourcePosition)
    case errorUnexpectedTuple(expected: Type, position: SourcePosition)
    case errorUnexpectedRecord(expected: Type, position: SourcePosition)
    case errorUnexpectedVariant(expected: Type, position: SourcePosition)
    case errorUnexpectedList(expected: Type, position: SourcePosition)
    case errorUnexpectedInjection(expected: Type, position: SourcePosition)
    case errorMissingRecordFields(missing: [String], position: SourcePosition)
    case errorUnexpectedRecordFields(unexpected: [String], position: SourcePosition)
    case errorUnexpectedFieldAccess(label: String, recordType: Type, position: SourcePosition)
    case errorUnexpectedVariantLabel(label: String, variantType: Type, position: SourcePosition)
    case errorMissingVariantLabels(missing: [String], position: SourcePosition)
    case errorTupleIndexOutOfBounds(index: Int, tupleSize: Int, position: SourcePosition)
    case errorUnexpectedTupleLength(expected: Int, found: Int, position: SourcePosition)
    case errorAmbiguousSumType(position: SourcePosition)
    case errorAmbiguousVariantType(position: SourcePosition)
    case errorAmbiguousListType(position: SourcePosition)
    case errorIllegalEmptyMatching(position: SourcePosition)
    case errorNonexhaustiveMatchPatterns(position: SourcePosition)
    case errorUnexpectedPatternForType(pattern: Pattern, type: Type)
    case errorDuplicateRecordFields(fields: [String], position: SourcePosition)
    case errorDuplicateRecordTypeFields(fields: [String], position: SourcePosition)
    case errorDuplicateVariantTypeFields(fields: [String], position: SourcePosition)
    
    var errorCode: String {
        switch self {
        case .errorMissingMain: return "ERROR_MISSING_MAIN"
        case .errorIncorrectTypeOfMain: return "ERROR_INCORRECT_TYPE_OF_MAIN"
        case .errorUndefinedVariable: return "ERROR_UNDEFINED_VARIABLE"
        case .errorIllegalNegativeLiteral: return "ERROR_ILLEGAL_NEGATIVE_LITERAL"
        case .errorUnexpectedTypeForExpression: return "ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION"
        case .errorNotAFunction: return "ERROR_NOT_A_FUNCTION"
        case .errorNotATuple: return "ERROR_NOT_A_TUPLE"
        case .errorNotARecord: return "ERROR_NOT_A_RECORD"
        case .errorNotAList: return "ERROR_NOT_A_LIST"
        case .errorUnexpectedLambda: return "ERROR_UNEXPECTED_LAMBDA"
        case .errorUnexpectedTypeForParameter: return "ERROR_UNEXPECTED_TYPE_FOR_PARAMETER"
        case .errorUnexpectedTuple: return "ERROR_UNEXPECTED_TUPLE"
        case .errorUnexpectedRecord: return "ERROR_UNEXPECTED_RECORD"
        case .errorUnexpectedVariant: return "ERROR_UNEXPECTED_VARIANT"
        case .errorUnexpectedList: return "ERROR_UNEXPECTED_LIST"
        case .errorUnexpectedInjection: return "ERROR_UNEXPECTED_INJECTION"
        case .errorMissingRecordFields: return "ERROR_MISSING_RECORD_FIELDS"
        case .errorUnexpectedRecordFields: return "ERROR_UNEXPECTED_RECORD_FIELDS"
        case .errorUnexpectedFieldAccess: return "ERROR_UNEXPECTED_FIELD_ACCESS"
        case .errorUnexpectedVariantLabel: return "ERROR_UNEXPECTED_VARIANT_LABEL"
        case .errorMissingVariantLabels: return "ERROR_MISSING_VARIANT_LABELS"
        case .errorTupleIndexOutOfBounds: return "ERROR_TUPLE_INDEX_OUT_OF_BOUNDS"
        case .errorUnexpectedTupleLength: return "ERROR_UNEXPECTED_TUPLE_LENGTH"
        case .errorAmbiguousSumType: return "ERROR_AMBIGUOUS_SUM_TYPE"
        case .errorAmbiguousVariantType: return "ERROR_AMBIGUOUS_VARIANT_TYPE"
        case .errorAmbiguousListType: return "ERROR_AMBIGUOUS_LIST_TYPE"
        case .errorIllegalEmptyMatching: return "ERROR_ILLEGAL_EMPTY_MATCHING"
        case .errorNonexhaustiveMatchPatterns: return "ERROR_NONEXHAUSTIVE_MATCH_PATTERNS"
        case .errorUnexpectedPatternForType: return "ERROR_UNEXPECTED_PATTERN_FOR_TYPE"
        case .errorDuplicateRecordFields: return "ERROR_DUPLICATE_RECORD_FIELDS"
        case .errorDuplicateRecordTypeFields: return "ERROR_DUPLICATE_RECORD_TYPE_FIELDS"
        case .errorDuplicateVariantTypeFields: return "ERROR_DUPLICATE_VARIANT_TYPE_FIELDS"
        }
    }
    
    var description: String {
        let code = errorCode
        switch self {
        case .errorMissingMain:
            return "\(code): The program does not contain a function 'main'"
            
        case .errorIncorrectTypeOfMain:
            return "\(code): The function 'main' does not have a function type"
            
        case .errorUndefinedVariable(let name, let pos):
            return """
            \(code):
            Undefined variable '\(name)' at line \(pos.line), column \(pos.column)
            """
            
        case .errorIllegalNegativeLiteral(let pos):
            return """
            \(code):
            Illegal negative literal at line \(pos.line), column \(pos.column)
            Only natural numbers (non-negative integers) are allowed
            """
            
        case .errorUnexpectedTypeForExpression(let expected, let found, let expr):
            return """
            \(code):
            expected type
              \(expected)
            but found type
              \(found)
            for expression
              \(expr)
            """
            
        case .errorNotAFunction(let expr, let actualType):
            return """
            \(code):
            Attempting to apply a non-function expression
            Expression: \(expr)
            Type: \(actualType)
            """
            
        case .errorNotATuple(let expr, let actualType):
            return """
            \(code):
            Attempting to access tuple component of a non-tuple expression
            Expression: \(expr)
            Type: \(actualType)
            """
            
        case .errorNotARecord(let expr, let actualType):
            return """
            \(code):
            Attempting to access field of a non-record expression
            Expression: \(expr)
            Type: \(actualType)
            """
            
        case .errorNotAList(let expr, let actualType):
            return """
            \(code):
            Attempting to use list operation on a non-list expression
            Expression: \(expr)
            Type: \(actualType)
            """
            
        case .errorUnexpectedLambda(let expected, let pos):
            return """
            \(code):
            Anonymous function checked against non-function type
            Expected type: \(expected)
            at line \(pos.line), column \(pos.column)
            """
            
        case .errorUnexpectedTypeForParameter(let expected, let found, let pos):
            return """
            \(code):
            Parameter type mismatch
            Expected: \(expected)
            Found: \(found)
            at line \(pos.line), column \(pos.column)
            """
            
        case .errorUnexpectedTuple(let expected, let pos):
            return """
            \(code):
            Tuple expression checked against non-tuple type
            Expected type: \(expected)
            at line \(pos.line), column \(pos.column)
            """
            
        case .errorUnexpectedRecord(let expected, let pos):
            return """
            \(code):
            Record expression checked against non-record type
            Expected type: \(expected)
            at line \(pos.line), column \(pos.column)
            """
            
        case .errorUnexpectedVariant(let expected, let pos):
            return """
            \(code):
            Variant expression checked against non-variant type
            Expected type: \(expected)
            at line \(pos.line), column \(pos.column)
            """
            
        case .errorUnexpectedList(let expected, let pos):
            return """
            \(code):
            List expression checked against non-list type
            Expected type: \(expected)
            at line \(pos.line), column \(pos.column)
            """
            
        case .errorUnexpectedInjection(let expected, let pos):
            return """
            \(code):
            Injection (inl/inr) checked against non-sum type
            Expected type: \(expected)
            at line \(pos.line), column \(pos.column)
            """
            
        case .errorMissingRecordFields(let missing, let pos):
            return """
            \(code):
            Record is missing required fields: \(missing.joined(separator: ", "))
            at line \(pos.line), column \(pos.column)
            """
            
        case .errorUnexpectedRecordFields(let unexpected, let pos):
            return """
            \(code):
            Record contains unexpected fields: \(unexpected.joined(separator: ", "))
            at line \(pos.line), column \(pos.column)
            """
            
        case .errorUnexpectedFieldAccess(let label, let recordType, let pos):
            return """
            \(code):
            Attempting to access non-existent field '\(label)'
            Record type: \(recordType)
            at line \(pos.line), column \(pos.column)
            """
            
        case .errorUnexpectedVariantLabel(let label, let variantType, let pos):
            return """
            \(code):
            Variant label '\(label)' is not present in the expected variant type
            Variant type: \(variantType)
            at line \(pos.line), column \(pos.column)
            """
            
        case .errorMissingVariantLabels(let missing, let pos):
            return """
            \(code):
            Missing variant labels: \(missing.joined(separator: ", "))
            at line \(pos.line), column \(pos.column)
            """
            
        case .errorTupleIndexOutOfBounds(let index, let tupleSize, let pos):
            return """
            \(code):
            Tuple index \(index) out of bounds (tuple size: \(tupleSize))
            at line \(pos.line), column \(pos.column)
            """
            
        case .errorUnexpectedTupleLength(let expected, let found, let pos):
            return """
            \(code):
            Tuple length mismatch
            Expected: \(expected)
            Found: \(found)
            at line \(pos.line), column \(pos.column)
            """
            
        case .errorAmbiguousSumType(let pos):
            return """
            \(code):
            Cannot determine sum type from context
            at line \(pos.line), column \(pos.column)
            """
            
        case .errorAmbiguousVariantType(let pos):
            return """
            \(code):
            Cannot determine variant type from context
            at line \(pos.line), column \(pos.column)
            """
            
        case .errorAmbiguousListType(let pos):
            return """
            \(code):
            Cannot determine list element type from context
            at line \(pos.line), column \(pos.column)
            """
            
        case .errorIllegalEmptyMatching(let pos):
            return """
            \(code):
            Match expression with empty list of alternatives
            at line \(pos.line), column \(pos.column)
            """
            
        case .errorNonexhaustiveMatchPatterns(let pos):
            return """
            \(code):
            Match patterns are not exhaustive
            at line \(pos.line), column \(pos.column)
            """
            
        case .errorUnexpectedPatternForType(let pattern, let type):
            return """
            \(code):
            Pattern does not match the scrutinized type
            Pattern: \(pattern)
            Type: \(type)
            """
            
        case .errorDuplicateRecordFields(let fields, let pos):
            return """
            \(code):
            Record expression contains duplicate fields: \(fields.joined(separator: ", "))
            at line \(pos.line), column \(pos.column)
            """
            
        case .errorDuplicateRecordTypeFields(let fields, let pos):
            return """
            \(code):
            Record type contains duplicate field names: \(fields.joined(separator: ", "))
            at line \(pos.line), column \(pos.column)
            """
            
        case .errorDuplicateVariantTypeFields(let fields, let pos):
            return """
            \(code):
            Variant type contains duplicate labels: \(fields.joined(separator: ", "))
            at line \(pos.line), column \(pos.column)
            """
        }
    }
}

// MARK: - Type Environment

typealias TypeContext = [String: Type]

// MARK: - Type Checker

class TypeChecker {
    private var globalContext: TypeContext = [:]
    
    /// Performs type checking for the whole program
    func typecheck(program: Program) throws {
        // 1. Checking for the presence of the main function
        guard let mainDecl = program.decls.first(where: { decl in
            if case .declFun(let name, _, _, _, _, _) = decl, name == "main" {
                return true
            }
            return false
        }) else {
            throw TypeCheckError.errorMissingMain
        }
        
        // 2. Collecting global context with all function types
        try buildGlobalContext(from: program.decls)
        
        // 3. Checking the type of the main function
        guard case .declFun(_, let params, _, _, _, _) = mainDecl else {
            throw TypeCheckError.errorIncorrectTypeOfMain
        }
        
        // In the core, Stella main must have exactly one parameter.
        guard params.count == 1 else {
            throw TypeCheckError.errorIncorrectTypeOfMain
        }
        
        // 4. Type check of all functions
        for decl in program.decls {
            try typecheckDecl(decl)
        }
    }
    
    /// Builds a global context with function types
    private func buildGlobalContext(from decls: [Decl]) throws {
        for decl in decls {
            guard case .declFun(let name, let params, let returnType, _, _, _) = decl else {
                continue
            }
            
            let paramTypes = params.map { $0.paramType }
            let funType: Type
            
            if let retType = returnType {
                funType = .function(paramTypes: paramTypes, returnType: retType)
            } else {
                fatalError("Function \(name) must have explicit return type")
            }
            
            globalContext[name] = funType
        }
    }
    
    /// Type check of declarations
    private func typecheckDecl(_ decl: Decl) throws {
        guard case .declFun(let name, let params, let returnType, let localDecls, let returnExpr, let declPos) = decl else {
            return
        }
        
        // Validate types in parameter declarations and return type
        for param in params {
            try validateType(param.paramType, at: declPos)
        }
        if let retType = returnType {
            try validateType(retType, at: declPos)
        }
        
        // Create a local context with parameters
        var localContext = globalContext
        for param in params {
            localContext[param.name] = param.paramType
        }
        
        // Add local function declarations to context
        for localDecl in localDecls {
            if case .declFun(let localName, let localParams, let localRetType, _, _, _) = localDecl {
                let localParamTypes = localParams.map { $0.paramType }
                if let ret = localRetType {
                    localContext[localName] = .function(paramTypes: localParamTypes, returnType: ret)
                }
            }
        }
        
        // Type check of local declarations (nested functions)
        for localDecl in localDecls {
            try typecheckDecl(localDecl)
        }
        
        // Type check of the function body
        guard let expectedReturnType = returnType else {
            fatalError("Function \(name) must have explicit return type")
        }
        
        try checkExpr(returnExpr, expectedType: expectedReturnType, context: localContext)
    }
    
    // MARK: - Checking Mode
    
    /// Checks the expression against the expected type (checking mode)
    private func checkExpr(_ expr: Expr, expectedType: Type, context: TypeContext) throws {
        switch (expr, expectedType) {
            
        // === Lambda against function type ===
        case (.abstraction(let params, let body, _), .function(let expectedParamTypes, let expectedReturnType)):
            guard params.count == expectedParamTypes.count else {
                throw TypeCheckError.errorUnexpectedTypeForExpression(
                    expected: expectedType,
                    found: .function(paramTypes: params.map { $0.paramType }, returnType: .nat),
                    expr: expr
                )
            }
            
            for (param, expectedParamType) in zip(params, expectedParamTypes) {
                if param.paramType != expectedParamType {
                    throw TypeCheckError.errorUnexpectedTypeForParameter(
                        expected: expectedParamType,
                        found: param.paramType,
                        position: param.position
                    )
                }
            }
            
            var bodyContext = context
            for param in params {
                bodyContext[param.name] = param.paramType
            }
            
            try checkExpr(body, expectedType: expectedReturnType, context: bodyContext)
            
        // === Tuple against tuple type ===
        case (.tuple(let exprs, let pos), .tuple(let expectedTypes)):
            guard exprs.count == expectedTypes.count else {
                throw TypeCheckError.errorUnexpectedTupleLength(
                    expected: expectedTypes.count,
                    found: exprs.count,
                    position: pos
                )
            }
            
            for (elemExpr, elemType) in zip(exprs, expectedTypes) {
                try checkExpr(elemExpr, expectedType: elemType, context: context)
            }
            
        // === Record against record type ===
        case (.record(let bindings, let pos), .record(let expectedFields)):
            // Check for duplicate fields in the record expression
            let bindingNames = bindings.map { $0.name }
            let duplicates = findDuplicates(in: bindingNames)
            if !duplicates.isEmpty {
                throw TypeCheckError.errorDuplicateRecordFields(fields: duplicates, position: pos)
            }
            
            let providedLabels = Set(bindings.map { $0.name })
            let expectedLabels = Set(expectedFields.map { $0.label })
            
            let missing = expectedLabels.subtracting(providedLabels)
            if !missing.isEmpty {
                throw TypeCheckError.errorMissingRecordFields(
                    missing: Array(missing).sorted(),
                    position: pos
                )
            }
            
            let unexpected = providedLabels.subtracting(expectedLabels)
            if !unexpected.isEmpty {
                throw TypeCheckError.errorUnexpectedRecordFields(
                    unexpected: Array(unexpected).sorted(),
                    position: pos
                )
            }
            
            for binding in bindings {
                guard let expectedField = expectedFields.first(where: { $0.label == binding.name }) else {
                    continue
                }
                try checkExpr(binding.rhs, expectedType: expectedField.fieldType, context: context)
            }
            
        // === Inl against sum type ===
        case (.inl(let innerExpr, _), .sum(let leftType, _)):
            try checkExpr(innerExpr, expectedType: leftType, context: context)
            
        // === Inr against sum type ===
        case (.inr(let innerExpr, _), .sum(_, let rightType)):
            try checkExpr(innerExpr, expectedType: rightType, context: context)
            
        // === List against list type ===
        case (.list(let exprs, _), .list(let elemType)):
            for elemExpr in exprs {
                try checkExpr(elemExpr, expectedType: elemType, context: context)
            }
            
        // === ConsList against list type ===
        case (.consList(let head, let tail, _), .list(let elemType)):
            try checkExpr(head, expectedType: elemType, context: context)
            try checkExpr(tail, expectedType: .list(elemType), context: context)
            
        // === Variant against variant type ===
        case (.variant(let label, let exprOpt, let pos), .variant(let fields)):
            guard let field = fields.first(where: { $0.label == label }) else {
                throw TypeCheckError.errorUnexpectedVariantLabel(
                    label: label,
                    variantType: expectedType,
                    position: pos
                )
            }
            
            switch (exprOpt, field.fieldType) {
            case (nil, nil):
                // Nullary variant — OK
                break
            case (let innerExpr?, let fieldType?):
                // Variant with data — check the type
                try checkExpr(innerExpr, expectedType: fieldType, context: context)
            case (nil, _?):
                // Data was expected, but not provided
                throw TypeCheckError.errorUnexpectedTypeForExpression(
                    expected: expectedType,
                    found: expectedType,
                    expr: expr
                )
            case (_?, nil):
                // Data provided, but not expected
                throw TypeCheckError.errorUnexpectedTypeForExpression(
                    expected: expectedType,
                    found: expectedType,
                    expr: expr
                )
            }
            
        // === if-then-else: synthesize branch type, compare with expected ===
        // This ensures error messages reference the full if-expression, not a sub-expression
        case (.ifExpr(let condition, let thenExpr, let elseExpr, _), _):
            try checkExpr(condition, expectedType: .bool, context: context)
            let thenType = try inferType(thenExpr, context: context)
            try checkExpr(elseExpr, expectedType: thenType, context: context)
            if thenType != expectedType {
                throw TypeCheckError.errorUnexpectedTypeForExpression(
                    expected: expectedType,
                    found: thenType,
                    expr: expr
                )
            }
            
        // === Propagate expected type through let ===
        case (.letExpr(let bindings, let body, _), _):
            var newContext = context
            for binding in bindings {
                let rhsType = try inferType(binding.rhs, context: newContext)
                if case .patternVar(let name, _) = binding.pattern {
                    newContext[name] = rhsType
                }
            }
            try checkExpr(body, expectedType: expectedType, context: newContext)
            
        // === Propagate expected type through match ===
        case (.match(let scrutinee, let cases, let pos), _):
            if cases.isEmpty {
                throw TypeCheckError.errorIllegalEmptyMatching(position: pos)
            }
            let scrutineeType = try inferType(scrutinee, context: context)
            for matchCase in cases {
                var caseContext = context
                try checkPattern(matchCase.pattern, against: scrutineeType, context: &caseContext)
                try checkExpr(matchCase.expr, expectedType: expectedType, context: caseContext)
            }
            try checkExhaustiveness(patterns: cases.map { $0.pattern }, against: scrutineeType, position: pos)
            
        // === Propagate expected type through parentheses ===
        case (.parenthesised(let innerExpr, _), _):
            try checkExpr(innerExpr, expectedType: expectedType, context: context)
            
        // === Specific type mismatch errors (must come before default) ===
            
        case (.abstraction(_, _, let pos), _):
            throw TypeCheckError.errorUnexpectedLambda(expected: expectedType, position: pos)
            
        case (.tuple(_, let pos), _):
            throw TypeCheckError.errorUnexpectedTuple(expected: expectedType, position: pos)
            
        case (.record(_, let pos), _):
            throw TypeCheckError.errorUnexpectedRecord(expected: expectedType, position: pos)
            
        case (.inl(_, let pos), _):
            throw TypeCheckError.errorUnexpectedInjection(expected: expectedType, position: pos)
            
        case (.inr(_, let pos), _):
            throw TypeCheckError.errorUnexpectedInjection(expected: expectedType, position: pos)
            
        case (.list(_, let pos), _):
            throw TypeCheckError.errorUnexpectedList(expected: expectedType, position: pos)
            
        case (.consList(_, _, let pos), _):
            throw TypeCheckError.errorUnexpectedList(expected: expectedType, position: pos)
            
        case (.variant(_, _, let pos), _):
            throw TypeCheckError.errorUnexpectedVariant(expected: expectedType, position: pos)
            
        // === Fallback to synthesis mode ===
        default:
            let inferredType = try inferType(expr, context: context)
            if inferredType != expectedType {
                // Check for specific variant label mismatch
                if case .variant(let inferredFields) = inferredType,
                   case .variant(let expectedFields) = expectedType {
                    let inferredLabels = Set(inferredFields.map { $0.label })
                    let expectedLabels = Set(expectedFields.map { $0.label })
                    let missing = expectedLabels.subtracting(inferredLabels)
                    if !missing.isEmpty {
                        throw TypeCheckError.errorMissingVariantLabels(
                            missing: Array(missing).sorted(),
                            position: expr.position
                        )
                    }
                }
                throw TypeCheckError.errorUnexpectedTypeForExpression(
                    expected: expectedType,
                    found: inferredType,
                    expr: expr
                )
            }
        }
    }
    
    // MARK: - Synthesis Mode
    
    /// Infers the type of expression (synthesis mode)
    private func inferType(_ expr: Expr, context: TypeContext) throws -> Type {
        switch expr {
        // Literals
        case .constTrue, .constFalse:
            return .bool
            
        case .constInt(let n, let pos):
            if n < 0 {
                throw TypeCheckError.errorIllegalNegativeLiteral(position: pos)
            }
            return .nat
            
        case .constUnit:
            return .unit
            
        // Variables
        case .variable(let name, let pos):
            guard let type = context[name] else {
                throw TypeCheckError.errorUndefinedVariable(name: name, position: pos)
            }
            return type
            
        // Functions
        case .abstraction(let params, let body, _):
            var bodyContext = context
            for param in params {
                bodyContext[param.name] = param.paramType
            }
            
            let returnType = try inferType(body, context: bodyContext)
            return .function(paramTypes: params.map { $0.paramType }, returnType: returnType)
            
        case .application(let fun, let args, _):
            let funType = try inferType(fun, context: context)
            
            guard case .function(let paramTypes, let returnType) = funType else {
                throw TypeCheckError.errorNotAFunction(expr: fun, actualType: funType)
            }
            
            guard args.count == paramTypes.count else {
                throw TypeCheckError.errorUnexpectedTypeForExpression(
                    expected: funType,
                    found: funType,
                    expr: expr
                )
            }
            
            for (arg, paramType) in zip(args, paramTypes) {
                try checkExpr(arg, expectedType: paramType, context: context)
            }
            
            return returnType
            
        // Conditionals
        case .ifExpr(let condition, let thenExpr, let elseExpr, _):
            try checkExpr(condition, expectedType: .bool, context: context)
            
            let thenType = try inferType(thenExpr, context: context)
            try checkExpr(elseExpr, expectedType: thenType, context: context)
            
            return thenType
            
        // Natural numbers
        case .succ(let n, _):
            try checkExpr(n, expectedType: .nat, context: context)
            return .nat
            
        case .pred(let n, _):
            try checkExpr(n, expectedType: .nat, context: context)
            return .nat
            
        case .isZero(let n, _):
            try checkExpr(n, expectedType: .nat, context: context)
            return .bool
            
        case .natRec(let n, let initial, let step, _):
            try checkExpr(n, expectedType: .nat, context: context)
            
            let initialType = try inferType(initial, context: context)
            
            // s : Nat → (T → T)  — curried function
            let expectedStepType = Type.function(
                paramTypes: [.nat],
                returnType: .function(paramTypes: [initialType], returnType: initialType)
            )
            try checkExpr(step, expectedType: expectedStepType, context: context)
            
            return initialType
            
        // Tuples
        case .tuple(let exprs, _):
            let types = try exprs.map { try inferType($0, context: context) }
            return .tuple(types)
            
        case .dotTuple(let tupleExpr, let index, let pos):
            let tupleType = try inferType(tupleExpr, context: context)
            
            guard case .tuple(let types) = tupleType else {
                throw TypeCheckError.errorNotATuple(expr: tupleExpr, actualType: tupleType)
            }
            
            guard index >= 1 && index <= types.count else {
                throw TypeCheckError.errorTupleIndexOutOfBounds(
                    index: index,
                    tupleSize: types.count,
                    position: pos
                )
            }
            
            return types[index - 1] // Indexes in Stella start with 1
            
        // Records
        case .record(let bindings, let pos):
            // Check for duplicate fields
            let bindingNames = bindings.map { $0.name }
            let duplicates = findDuplicates(in: bindingNames)
            if !duplicates.isEmpty {
                throw TypeCheckError.errorDuplicateRecordFields(fields: duplicates, position: pos)
            }
            
            var fields: [RecordFieldType] = []
            for binding in bindings {
                let fieldType = try inferType(binding.rhs, context: context)
                fields.append(RecordFieldType(label: binding.name, fieldType: fieldType))
            }
            return .record(fields)
            
        case .dotRecord(let recordExpr, let label, let pos):
            let recordType = try inferType(recordExpr, context: context)
            
            guard case .record(let fields) = recordType else {
                throw TypeCheckError.errorNotARecord(expr: recordExpr, actualType: recordType)
            }
            
            guard let field = fields.first(where: { $0.label == label }) else {
                throw TypeCheckError.errorUnexpectedFieldAccess(
                    label: label,
                    recordType: recordType,
                    position: pos
                )
            }
            
            return field.fieldType
            
        // Type ascription
        case .typeAsc(let innerExpr, let type, let pos):
            try validateType(type, at: pos)
            try checkExpr(innerExpr, expectedType: type, context: context)
            return type
            
        // Let bindings
        case .letExpr(let bindings, let body, _):
            var newContext = context
            for binding in bindings {
                let rhsType = try inferType(binding.rhs, context: newContext)
                if case .patternVar(let name, _) = binding.pattern {
                    newContext[name] = rhsType
                }
            }
            return try inferType(body, context: newContext)
            
        // Fixpoint
        case .fix(let f, _):
            let fType = try inferType(f, context: context)
            
            guard case .function(let paramTypes, let returnType) = fType else {
                throw TypeCheckError.errorNotAFunction(expr: f, actualType: fType)
            }
            
            guard paramTypes.count == 1 else {
                throw TypeCheckError.errorUnexpectedTypeForExpression(
                    expected: .function(paramTypes: [returnType], returnType: returnType),
                    found: fType,
                    expr: expr
                )
            }
            
            // fix requires f : T -> T
            if paramTypes[0] != returnType {
                throw TypeCheckError.errorUnexpectedTypeForExpression(
                    expected: .function(paramTypes: [returnType], returnType: returnType),
                    found: fType,
                    expr: expr
                )
            }
            
            return returnType
            
        // Lists
        case .list(let exprs, let pos):
            if exprs.isEmpty {
                // Empty list — context needed
                throw TypeCheckError.errorAmbiguousListType(position: pos)
            }
            
            let elemType = try inferType(exprs[0], context: context)
            for elemExpr in exprs.dropFirst() {
                try checkExpr(elemExpr, expectedType: elemType, context: context)
            }
            return .list(elemType)
            
        case .consList(let head, let tail, _):
            let headType = try inferType(head, context: context)
            try checkExpr(tail, expectedType: .list(headType), context: context)
            return .list(headType)
            
        case .head(let list, _):
            let listType = try inferType(list, context: context)
            
            guard case .list(let elemType) = listType else {
                throw TypeCheckError.errorNotAList(expr: list, actualType: listType)
            }
            
            return elemType
            
        case .tail(let list, _):
            let listType = try inferType(list, context: context)
            
            guard case .list(_) = listType else {
                throw TypeCheckError.errorNotAList(expr: list, actualType: listType)
            }
            
            return listType
            
        case .isEmpty(let list, _):
            let listType = try inferType(list, context: context)
            
            guard case .list(_) = listType else {
                throw TypeCheckError.errorNotAList(expr: list, actualType: listType)
            }
            
            return .bool
            
        // Match
        case .match(let scrutinee, let cases, let pos):
            if cases.isEmpty {
                throw TypeCheckError.errorIllegalEmptyMatching(position: pos)
            }
            
            let scrutineeType = try inferType(scrutinee, context: context)
            
            // Type check the first case and get the resulting type
            let firstCase = cases[0]
            var newContext = context
            try checkPattern(firstCase.pattern, against: scrutineeType, context: &newContext)
            let resultType = try inferType(firstCase.expr, context: newContext)
            
            // Type check the remaining cases
            for case_ in cases.dropFirst() {
                var caseContext = context
                try checkPattern(case_.pattern, against: scrutineeType, context: &caseContext)
                try checkExpr(case_.expr, expectedType: resultType, context: caseContext)
            }
            
            // Exhaustiveness check
            try checkExhaustiveness(patterns: cases.map { $0.pattern }, against: scrutineeType, position: pos)
            
            return resultType
            
        // Sum types (cannot be inferred without context)
        case .inl(_, let pos):
            throw TypeCheckError.errorAmbiguousSumType(position: pos)
            
        case .inr(_, let pos):
            throw TypeCheckError.errorAmbiguousSumType(position: pos)
            
        // Variants (cannot be inferred without context)
        case .variant(_, _, let pos):
            throw TypeCheckError.errorAmbiguousVariantType(position: pos)
            
        // Parenthesised
        case .parenthesised(let innerExpr, _):
            return try inferType(innerExpr, context: context)
            
        // Other operations (for extensions)
        default:
            fatalError("Type inference for \(expr) not yet implemented")
        }
    }
    
    // MARK: - Pattern Checking
    
    /// Checks the pattern against the type and adds related variables to the context
    private func checkPattern(_ pattern: Pattern, against type: Type, context: inout TypeContext) throws {
        switch (pattern, type) {
        case (.patternVar(let name, _), _):
            context[name] = type
            
        case (.patternTrue, .bool), (.patternFalse, .bool):
            break
            
        case (.patternUnit, .unit):
            break
            
        case (.patternInt(let n, let pos), .nat):
            if n < 0 {
                throw TypeCheckError.errorIllegalNegativeLiteral(position: pos)
            }
            
        case (.patternSucc(let innerPattern, _), .nat):
            try checkPattern(innerPattern, against: .nat, context: &context)
            
        case (.patternInl(let innerPattern, _), .sum(let leftType, _)):
            try checkPattern(innerPattern, against: leftType, context: &context)
            
        case (.patternInr(let innerPattern, _), .sum(_, let rightType)):
            try checkPattern(innerPattern, against: rightType, context: &context)
            
        case (.patternTuple(let patterns, _), .tuple(let types)):
            guard patterns.count == types.count else {
                throw TypeCheckError.errorUnexpectedPatternForType(pattern: pattern, type: type)
            }
            for (pat, ty) in zip(patterns, types) {
                try checkPattern(pat, against: ty, context: &context)
            }
            
        case (.patternList(let patterns, _), .list(let elemType)):
            for pat in patterns {
                try checkPattern(pat, against: elemType, context: &context)
            }
            
        case (.patternCons(let head, let tail, _), .list(let elemType)):
            try checkPattern(head, against: elemType, context: &context)
            try checkPattern(tail, against: .list(elemType), context: &context)
            
        case (.patternVariant(let label, let innerPat, _), .variant(let fields)):
            guard let field = fields.first(where: { $0.label == label }) else {
                throw TypeCheckError.errorUnexpectedPatternForType(pattern: pattern, type: type)
            }
            switch (innerPat, field.fieldType) {
            case (nil, nil):
                break // nullary variant — OK
            case (let pat?, let fieldType?):
                try checkPattern(pat, against: fieldType, context: &context)
            default:
                throw TypeCheckError.errorUnexpectedPatternForType(pattern: pattern, type: type)
            }
            
        default:
            throw TypeCheckError.errorUnexpectedPatternForType(pattern: pattern, type: type)
        }
    }
    
    // MARK: - Exhaustiveness Checking
    
    /// Checks that patterns in a match expression are exhaustive
    private func checkExhaustiveness(patterns: [Pattern], against type: Type, position: SourcePosition) throws {
        switch type {
        case .sum:
            var hasInl = false
            var hasInr = false
            for pattern in patterns {
                switch pattern {
                case .patternInl: hasInl = true
                case .patternInr: hasInr = true
                case .patternVar: hasInl = true; hasInr = true // catch-all
                default: break
                }
            }
            if !hasInl || !hasInr {
                throw TypeCheckError.errorNonexhaustiveMatchPatterns(position: position)
            }
            
        case .variant(let fields):
            let expectedLabels = Set(fields.map { $0.label })
            var coveredLabels = Set<String>()
            var hasCatchAll = false
            for pattern in patterns {
                switch pattern {
                case .patternVariant(let label, _, _):
                    coveredLabels.insert(label)
                case .patternVar:
                    hasCatchAll = true
                default: break
                }
            }
            if !hasCatchAll {
                let missing = expectedLabels.subtracting(coveredLabels)
                if !missing.isEmpty {
                    throw TypeCheckError.errorNonexhaustiveMatchPatterns(position: position)
                }
            }
            
        case .bool:
            var hasTrue = false
            var hasFalse = false
            for pattern in patterns {
                switch pattern {
                case .patternTrue: hasTrue = true
                case .patternFalse: hasFalse = true
                case .patternVar: hasTrue = true; hasFalse = true // catch-all
                default: break
                }
            }
            if !hasTrue || !hasFalse {
                throw TypeCheckError.errorNonexhaustiveMatchPatterns(position: position)
            }
            
        default:
            // For Nat, lists, etc. — a patternVar is considered exhaustive
            // Without further analysis, we don't enforce exhaustiveness for these types
            break
        }
    }
    
    // MARK: - Type Validation
    
    /// Validates that a type does not contain duplicate fields/labels
    private func validateType(_ type: Type, at position: SourcePosition = .unknown) throws {
        switch type {
        case .record(let fields):
            let labels = fields.map { $0.label }
            let duplicates = findDuplicates(in: labels)
            if !duplicates.isEmpty {
                throw TypeCheckError.errorDuplicateRecordTypeFields(fields: duplicates, position: position)
            }
            for field in fields {
                try validateType(field.fieldType, at: position)
            }
            
        case .variant(let fields):
            let labels = fields.map { $0.label }
            let duplicates = findDuplicates(in: labels)
            if !duplicates.isEmpty {
                throw TypeCheckError.errorDuplicateVariantTypeFields(fields: duplicates, position: position)
            }
            for field in fields {
                if let fieldType = field.fieldType {
                    try validateType(fieldType, at: position)
                }
            }
            
        case .function(let paramTypes, let returnType):
            for pt in paramTypes { try validateType(pt, at: position) }
            try validateType(returnType, at: position)
            
        case .tuple(let types):
            for t in types { try validateType(t, at: position) }
            
        case .sum(let left, let right):
            try validateType(left, at: position)
            try validateType(right, at: position)
            
        case .list(let elemType):
            try validateType(elemType, at: position)
            
        default:
            break
        }
    }
    
    // MARK: - Helpers
    
    /// Finds duplicate entries in an array of strings
    private func findDuplicates(in array: [String]) -> [String] {
        var seen = Set<String>()
        var duplicates = Set<String>()
        for item in array {
            if seen.contains(item) {
                duplicates.insert(item)
            }
            seen.insert(item)
        }
        return Array(duplicates).sorted()
    }
}
