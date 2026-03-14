// TypeChecker.swift
// Type checker for Stella language

import Foundation

// MARK: - Type Checking Errors

enum TypeCheckError: Error, CustomStringConvertible {
    
    // --- Stage 1 errors ---
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

    // --- Stage 2 errors ---
    /// Used exceptions without declaring `exception type = T`
    case errorExceptionTypeNotDeclared(position: SourcePosition)
    /// `throw(e)` used in synthesis mode (no expected type) without #ambiguous-type-as-bottom
    case errorAmbiguousThrowType(position: SourcePosition)
    /// `@address` used in synthesis mode (no expected type) without #ambiguous-type-as-bottom
    case errorAmbiguousReferenceType(position: SourcePosition)
    /// `panic!` used in synthesis mode (no expected type) without #ambiguous-type-as-bottom
    case errorAmbiguousPanicType(position: SourcePosition)
    /// Attempted to dereference or assign to an expression that is not of reference type
    case errorNotAReference(expr: Expr, actualType: Type, position: SourcePosition)
    /// `@address` used where a non-reference type is expected
    case errorUnexpectedMemoryAddress(expected: Type, position: SourcePosition)
    /// `new(e)` used where a non-reference type is expected
    case errorUnexpectedReference(expected: Type, position: SourcePosition)
    /// Type of expression is not a subtype of the expected type (only when #structural-subtyping is on)
    case errorUnexpectedSubtype(expected: Type, found: Type, expr: Expr)

    var errorCode: String {
        switch self {
            // Stage 1
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
        // Stage 2
        case .errorExceptionTypeNotDeclared: return "ERROR_EXCEPTION_TYPE_NOT_DECLARED"
        case .errorAmbiguousThrowType: return "ERROR_AMBIGUOUS_THROW_TYPE"
        case .errorAmbiguousReferenceType: return "ERROR_AMBIGUOUS_REFERENCE_TYPE"
        case .errorAmbiguousPanicType: return "ERROR_AMBIGUOUS_PANIC_TYPE"
        case .errorNotAReference: return "ERROR_NOT_A_REFERENCE"
        case .errorUnexpectedMemoryAddress: return "ERROR_UNEXPECTED_MEMORY_ADDRESS"
        case .errorUnexpectedReference: return "ERROR_UNEXPECTED_REFERENCE"
        case .errorUnexpectedSubtype: return "ERROR_UNEXPECTED_SUBTYPE"
        }
    }

    var description: String {
        let code = errorCode
        switch self {
            
        // --- Stage 1 error messages ---
            
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

        // --- Stage 2 error messages ---

        case .errorExceptionTypeNotDeclared(let pos):
            return """
            \(code):
            Exception type is not declared — add 'exception type = <type>' at the top level
            at line \(pos.line), column \(pos.column)
            """

        case .errorAmbiguousThrowType(let pos):
            return """
            \(code):
            Cannot determine the return type of a throw expression without context
            at line \(pos.line), column \(pos.column)
            (hint: enable #ambiguous-type-as-bottom or place throw in a typed context)
            """

        case .errorAmbiguousReferenceType(let pos):
            return """
            \(code):
            Cannot determine the type of a memory address literal without context
            at line \(pos.line), column \(pos.column)
            (hint: use the address where a reference type &T is expected)
            """

        case .errorAmbiguousPanicType(let pos):
            return """
            \(code):
            Cannot determine the return type of panic! without context
            at line \(pos.line), column \(pos.column)
            (hint: enable #ambiguous-type-as-bottom or place panic! in a typed context)
            """

        case .errorNotAReference(let expr, let actualType, let pos):
            return """
            \(code):
            Expected a reference type (&T) but got \(actualType)
            Expression: \(expr)
            at line \(pos.line), column \(pos.column)
            """

        case .errorUnexpectedMemoryAddress(let expected, let pos):
            return """
            \(code):
            Memory address used where type \(expected) (not a reference type) is expected
            at line \(pos.line), column \(pos.column)
            """

        case .errorUnexpectedReference(let expected, let pos):
            return """
            \(code):
            Reference expression (new(...)) used where type \(expected) (not &T) is expected
            at line \(pos.line), column \(pos.column)
            """

        case .errorUnexpectedSubtype(let expected, let found, let expr):
            return """
            \(code):
            expected a subtype of type
              \(expected)
            but found type
              \(found)
            for expression
              \(expr)
            """
        }
    }
}

// MARK: - Type Environment

typealias TypeContext = [String: Type]

// MARK: - Type Checker

class TypeChecker {
    private var globalContext: TypeContext = [:]

    // --- Stage 2 flags, read from `extend with` declarations ---

    /// True when #structural-subtyping is declared; enables the subtype relation
    private var structuralSubtyping: Bool = false

    /// True when #ambiguous-type-as-bottom is declared; ambiguous types default to Bot
    private var ambiguousTypeAsBottom: Bool = false

    /// The declared exception type (from `exception type = T`), or nil if not declared
    private var exceptionType: Type? = nil

    // MARK: - Entry Point

    /// Performs type checking for the whole program
    func typecheck(program: Program) throws {
        // 1. Read declared extensions and set checker flags
        let allExtNames = program.extensions.flatMap { $0.names }
        structuralSubtyping   = allExtNames.contains("#structural-subtyping")
        ambiguousTypeAsBottom = allExtNames.contains("#ambiguous-type-as-bottom")

        // 2. Scan top-level declarations for exception type declaration
        for decl in program.decls {
            if case .declExceptionType(let exType, _) = decl {
                exceptionType = exType
            }
        }

        // 3. Check for presence of 'main'
        guard let mainDecl = program.decls.first(where: { decl in
            if case .declFun(let name, _, _, _, _, _) = decl, name == "main" {
                return true
            }
            return false
        }) else {
            throw TypeCheckError.errorMissingMain
        }

        // 4. Build global context from all function declarations
        try buildGlobalContext(from: program.decls)

        // 5. Verify 'main' has exactly one parameter (required by Stella core)
        guard case .declFun(_, let params, _, _, _, _) = mainDecl, params.count == 1 else {
            throw TypeCheckError.errorIncorrectTypeOfMain
        }

        // 6. Type-check each declaration
        for decl in program.decls {
            try typecheckDecl(decl)
        }
    }

    // MARK: - Global Context Construction

    /// Populates `globalContext` with the function types of all top-level `declFun`s.
    private func buildGlobalContext(from decls: [Decl]) throws {
        for decl in decls {
            guard case .declFun(let name, let params, let returnType, _, _, _) = decl else {
                continue  // skip declExceptionType and any future non-function decls
            }

            let paramTypes = params.map { $0.paramType }
            guard let retType = returnType else {
                fatalError("Function \(name) must have explicit return type")
            }
            globalContext[name] = .function(paramTypes: paramTypes, returnType: retType)
        }
    }

    // MARK: - Declaration Type Checking

    /// Type-checks a single declaration.
    private func typecheckDecl(_ decl: Decl) throws {
        switch decl {
        case .declFun(let name, let params, let returnType, let localDecls, let returnExpr, let declPos):
            // Validate declared parameter types and return type
            for param in params {
                try validateType(param.paramType, at: declPos)
            }
            if let retType = returnType {
                try validateType(retType, at: declPos)
            }

            // Build local context: global + parameters
            var localContext = globalContext
            for param in params {
                localContext[param.name] = param.paramType
            }

            // Add nested local functions to context
            for localDecl in localDecls {
                if case .declFun(let localName, let localParams, let localRetType, _, _, _) = localDecl {
                    let localParamTypes = localParams.map { $0.paramType }
                    if let ret = localRetType {
                        localContext[localName] = .function(paramTypes: localParamTypes, returnType: ret)
                    }
                }
            }

            // Type-check nested function declarations
            for localDecl in localDecls {
                try typecheckDecl(localDecl)
            }

            // Type-check the function body against the declared return type
            guard let expectedReturnType = returnType else {
                fatalError("Function \(name) must have explicit return type")
            }
            try checkExpr(returnExpr, expectedType: expectedReturnType, context: localContext)

        case .declExceptionType:
            // Exception type declarations are processed at program level; nothing to check here
            break
        }
    }

    // MARK: - Checking Mode

    /// Checks `expr` against `expectedType` in checking (top-down) mode.
    /// This mode is used when we already know what type is expected — it gives better error messages
    /// for structured forms like lambdas, tuples, records, etc.
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
        // With structural subtyping, a tuple with MORE elements is a subtype (width subtyping).
        case (.tuple(let exprs, let pos), .tuple(let expectedTypes)):
            if structuralSubtyping {
                // A longer tuple is a subtype of a shorter one; require at least as many elements
                guard exprs.count >= expectedTypes.count else {
                    throw TypeCheckError.errorUnexpectedTupleLength(
                        expected: expectedTypes.count, found: exprs.count, position: pos
                    )
                }
                for (elemExpr, elemType) in zip(exprs, expectedTypes) {
                    try checkExpr(elemExpr, expectedType: elemType, context: context)
                }
            } else {
                guard exprs.count == expectedTypes.count else {
                    throw TypeCheckError.errorUnexpectedTupleLength(
                        expected: expectedTypes.count, found: exprs.count, position: pos
                    )
                }
                for (elemExpr, elemType) in zip(exprs, expectedTypes) {
                    try checkExpr(elemExpr, expectedType: elemType, context: context)
                }
            }

        // === Record against record type ===
        // With structural subtyping, extra fields are allowed (width subtyping for records).
        case (.record(let bindings, let pos), .record(let expectedFields)):
            let bindingNames = bindings.map { $0.name }
            let duplicates = findDuplicates(in: bindingNames)
            if !duplicates.isEmpty {
                throw TypeCheckError.errorDuplicateRecordFields(fields: duplicates, position: pos)
            }

            let providedLabels = Set(bindings.map { $0.name })
            let expectedLabels = Set(expectedFields.map { $0.label })

            // Missing fields are always an error regardless of subtyping
            let missing = expectedLabels.subtracting(providedLabels)
            if !missing.isEmpty {
                throw TypeCheckError.errorMissingRecordFields(
                    missing: Array(missing).sorted(), position: pos
                )
            }

            // Unexpected fields are only an error without structural subtyping
            if !structuralSubtyping {
                let unexpected = providedLabels.subtracting(expectedLabels)
                if !unexpected.isEmpty {
                    throw TypeCheckError.errorUnexpectedRecordFields(
                        unexpected: Array(unexpected).sorted(), position: pos
                    )
                }
            }

            // Check that each expected field has the right type
            for binding in bindings {
                guard let expectedField = expectedFields.first(where: { $0.label == binding.name }) else {
                    // Extra field (only reached when structural subtyping is on);
                    // just validate the expression itself without a specific expected type
                    _ = try inferType(binding.rhs, context: context)
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
                    label: label, variantType: expectedType, position: pos
                )
            }
            switch (exprOpt, field.fieldType) {
            case (nil, nil):
                break  // nullary variant — OK
            case (let innerExpr?, let fieldType?):
                try checkExpr(innerExpr, expectedType: fieldType, context: context)
            case (nil, _?):
                throw TypeCheckError.errorUnexpectedTypeForExpression(
                    expected: expectedType, found: expectedType, expr: expr
                )
            case (_?, nil):
                throw TypeCheckError.errorUnexpectedTypeForExpression(
                    expected: expectedType, found: expectedType, expr: expr
                )
            }

        // === panic! — a diverging expression, valid at any expected type ===
        case (.panic_(_), _):
            break  // panic! is bottom-typed; always accepted in any checking context

        // === throw(e) — check e has the exception type; result can be any type ===
        case (.throw_(let innerExpr, let pos), _):
            guard let excType = exceptionType else {
                throw TypeCheckError.errorExceptionTypeNotDeclared(position: pos)
            }
            try checkExpr(innerExpr, expectedType: excType, context: context)
            // throw never returns, so any return type is satisfied

        // === new(e) against &T ===
        case (.newRef(let innerExpr, _), .ref(let innerType)):
            try checkExpr(innerExpr, expectedType: innerType, context: context)

        // === new(e) against a non-reference type — error ===
        case (.newRef(_, let pos), _):
            throw TypeCheckError.errorUnexpectedReference(expected: expectedType, position: pos)

        // === @address against &T — valid memory address literal ===
        case (.constMemory, .ref):
            break  // memory address is valid wherever a reference type is expected

        // === @address against a non-reference type — error ===
        case (.constMemory(_, let pos), _):
            throw TypeCheckError.errorUnexpectedMemoryAddress(expected: expectedType, position: pos)

        // === Propagate expected type through if-then-else ===
        // Both branches are checked against the known expected type.
        // This allows diverging expressions like `panic!` and `throw` in branches.
        case (.ifExpr(let condition, let thenExpr, let elseExpr, _), _):
            try checkExpr(condition, expectedType: .bool, context: context)
            try checkExpr(thenExpr, expectedType: expectedType, context: context)
            try checkExpr(elseExpr, expectedType: expectedType, context: context)

        // === Propagate expected type through let bindings ===
        case (.letExpr(let bindings, let body, _), _):
            var newContext = context
            for binding in bindings {
                let rhsType = try inferType(binding.rhs, context: newContext)
                try bindPattern(binding.pattern, to: rhsType, context: &newContext)
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

        // === Specific structural-mismatch errors (must come before fallback default) ===

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

        // === Fallback: synthesize type and compare (with or without subtyping) ===
        default:
            let inferredType = try inferType(expr, context: context)
            try expectType(inferredType, toBeSubtypeOf: expectedType, expr: expr)
        }
    }

    // MARK: - Synthesis Mode

    /// Infers (synthesizes) the type of `expr` bottom-up.
    private func inferType(_ expr: Expr, context: TypeContext) throws -> Type {
        switch expr {

        // ---- Literals ----
        case .constTrue, .constFalse:
            return .bool

        case .constInt(let n, let pos):
            if n < 0 { throw TypeCheckError.errorIllegalNegativeLiteral(position: pos) }
            return .nat

        case .constUnit:
            return .unit

        // ---- Variables ----
        case .variable(let name, let pos):
            guard let type = context[name] else {
                throw TypeCheckError.errorUndefinedVariable(name: name, position: pos)
            }
            return type

        // ---- Functions ----
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
                    expected: funType, found: funType, expr: expr
                )
            }
            for (arg, paramType) in zip(args, paramTypes) {
                try checkExpr(arg, expectedType: paramType, context: context)
            }
            return returnType

        // ---- Conditionals ----
        case .ifExpr(let condition, let thenExpr, let elseExpr, _):
            try checkExpr(condition, expectedType: .bool, context: context)
            let thenType = try inferType(thenExpr, context: context)
            try checkExpr(elseExpr, expectedType: thenType, context: context)
            return thenType

        // ---- Natural numbers ----
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
            // step : Nat → (T → T)  (curried)
            let expectedStepType = Type.function(
                paramTypes: [.nat],
                returnType: .function(paramTypes: [initialType], returnType: initialType)
            )
            try checkExpr(step, expectedType: expectedStepType, context: context)
            return initialType

        // ---- Tuples ----
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
                    index: index, tupleSize: types.count, position: pos
                )
            }
            return types[index - 1]  // Stella tuple indices are 1-based

        // ---- Records ----
        case .record(let bindings, let pos):
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
                    label: label, recordType: recordType, position: pos
                )
            }
            return field.fieldType

        // ---- Type ascription ----
        case .typeAsc(let innerExpr, let type, let pos):
            try validateType(type, at: pos)
            try checkExpr(innerExpr, expectedType: type, context: context)
            return type

        // ---- Let bindings ----
        case .letExpr(let bindings, let body, _):
            var newContext = context
            for binding in bindings {
                let rhsType = try inferType(binding.rhs, context: newContext)
                try bindPattern(binding.pattern, to: rhsType, context: &newContext)
            }
            return try inferType(body, context: newContext)

        case .letRec(let bindings, let body, _):
            // letRec: treat like letExpr but with mutual recursion support.
            // Pre-populate context with function types where possible so recursive calls resolve.
            var newContext = context
            for binding in bindings {
                if case .abstraction(let params, _, _) = binding.rhs,
                   case .patternVar(let name, _) = binding.pattern {
                    // Create a placeholder type from the declared param types;
                    // the return type is inferred on a second pass below.
                    let paramTypes = params.map { $0.paramType }
                    // Use Bot as a placeholder for return type during the recursive pre-pass
                    newContext[name] = .function(paramTypes: paramTypes, returnType: .bot)
                }
            }
            // Now infer proper types and update context
            for binding in bindings {
                let rhsType = try inferType(binding.rhs, context: newContext)
                try bindPattern(binding.pattern, to: rhsType, context: &newContext)
            }
            return try inferType(body, context: newContext)

        // ---- Fixpoint ----
        case .fix(let f, _):
            let fType = try inferType(f, context: context)
            guard case .function(let paramTypes, let returnType) = fType else {
                throw TypeCheckError.errorNotAFunction(expr: f, actualType: fType)
            }
            guard paramTypes.count == 1 else {
                throw TypeCheckError.errorUnexpectedTypeForExpression(
                    expected: .function(paramTypes: [returnType], returnType: returnType),
                    found: fType, expr: expr
                )
            }
            // fix requires f : T → T (param type must equal return type)
            if paramTypes[0] != returnType {
                throw TypeCheckError.errorUnexpectedTypeForExpression(
                    expected: .function(paramTypes: [returnType], returnType: returnType),
                    found: fType, expr: expr
                )
            }
            return returnType

        // ---- Lists ----
        case .list(let exprs, let pos):
            if exprs.isEmpty {
                if ambiguousTypeAsBottom { return .list(.bot) }
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

        // ---- Match ----
        case .match(let scrutinee, let cases, let pos):
            if cases.isEmpty { throw TypeCheckError.errorIllegalEmptyMatching(position: pos) }
            let scrutineeType = try inferType(scrutinee, context: context)

            // Type-check the first case to determine the result type
            let firstCase = cases[0]
            var firstContext = context
            try checkPattern(firstCase.pattern, against: scrutineeType, context: &firstContext)
            let resultType = try inferType(firstCase.expr, context: firstContext)

            // Remaining cases must produce the same result type
            for case_ in cases.dropFirst() {
                var caseContext = context
                try checkPattern(case_.pattern, against: scrutineeType, context: &caseContext)
                try checkExpr(case_.expr, expectedType: resultType, context: caseContext)
            }
            try checkExhaustiveness(patterns: cases.map { $0.pattern }, against: scrutineeType, position: pos)
            return resultType

        // ---- Sum types — require context to infer ----
        case .inl(let innerExpr, let pos):
            if ambiguousTypeAsBottom {
                // Without context, the missing (right) side defaults to Bot: inl(e) : T + Bot
                let innerType = try inferType(innerExpr, context: context)
                return .sum(left: innerType, right: .bot)
            }
            throw TypeCheckError.errorAmbiguousSumType(position: pos)

        case .inr(let innerExpr, let pos):
            if ambiguousTypeAsBottom {
                // Without context, the missing (left) side defaults to Bot: inr(e) : Bot + T
                let innerType = try inferType(innerExpr, context: context)
                return .sum(left: .bot, right: innerType)
            }
            throw TypeCheckError.errorAmbiguousSumType(position: pos)

        // ---- Variants — require context ----
        case .variant(_, _, let pos):
            throw TypeCheckError.errorAmbiguousVariantType(position: pos)

        // ---- Parenthesised ----
        case .parenthesised(let innerExpr, _):
            return try inferType(innerExpr, context: context)

        // ---- Sequencing (#sequencing): e1 ; e2  ----
        // e1 must be Unit, the result is the type of e2
        case .sequence(let e1, let e2, _):
            try checkExpr(e1, expectedType: .unit, context: context)
            return try inferType(e2, context: context)

        // ---- References (#references) ----

        /// new(e) — allocate a fresh reference cell containing a value of type T
        case .newRef(let innerExpr, _):
            let innerType = try inferType(innerExpr, context: context)
            return .ref(innerType)

        /// *e — dereference: e must have type &T, result is T
        case .deref(let innerExpr, let pos):
            let innerType = try inferType(innerExpr, context: context)
            guard case .ref(let refInnerType) = innerType else {
                throw TypeCheckError.errorNotAReference(expr: innerExpr, actualType: innerType, position: pos)
            }
            return refInnerType

        /// lhs := rhs — assignment: lhs must be &T, rhs must be T, result is Unit
        case .assign(let lhs, let rhs, let pos):
            let lhsType = try inferType(lhs, context: context)
            guard case .ref(let refInnerType) = lhsType else {
                throw TypeCheckError.errorNotAReference(expr: lhs, actualType: lhsType, position: pos)
            }
            try checkExpr(rhs, expectedType: refInnerType, context: context)
            return .unit

        /// @address — memory address literal in synthesis mode
        case .constMemory(_, let pos):
            if ambiguousTypeAsBottom { return .ref(.bot) }
            throw TypeCheckError.errorAmbiguousReferenceType(position: pos)

        // ---- Panic (#panic) ----

        /// panic! in synthesis mode — type is ambiguous
        case .panic_(let pos):
            if ambiguousTypeAsBottom { return .bot }
            throw TypeCheckError.errorAmbiguousPanicType(position: pos)

        // ---- Exceptions (#exceptions) ----

        /// throw(e) — check e against the declared exception type, result is Bottom
        case .throw_(let innerExpr, let pos):
            guard let excType = exceptionType else {
                throw TypeCheckError.errorExceptionTypeNotDeclared(position: pos)
            }
            try checkExpr(innerExpr, expectedType: excType, context: context)
            if ambiguousTypeAsBottom { return .bot }
            throw TypeCheckError.errorAmbiguousThrowType(position: pos)

        /// try { e1 } with { e2 } — both branches must have the same type
        case .tryWith(let tryExpr, let fallback, _):
            let tryType = try inferType(tryExpr, context: context)
            try checkExpr(fallback, expectedType: tryType, context: context)
            return tryType

        /// try { e1 } catch { pat => e2 } — pat binds exception value
        case .tryCatch(let tryExpr, let pat, let fallback, let pos):
            guard let excType = exceptionType else {
                throw TypeCheckError.errorExceptionTypeNotDeclared(position: pos)
            }
            let tryType = try inferType(tryExpr, context: context)
            var catchContext = context
            try checkPattern(pat, against: excType, context: &catchContext)
            try checkExpr(fallback, expectedType: tryType, context: catchContext)
            return tryType

        // ---- Type cast (#type-cast) ----

        /// e cast as T — result type is always T (runtime check; static checker just returns T)
        case .typeCast(let innerExpr, let type, let pos):
            try validateType(type, at: pos)
            _ = try inferType(innerExpr, context: context)  // validate inner expr is well-typed
            return type

        // ---- Arithmetic operators ----
        case .add(let l, let r, _), .subtract(let l, let r, _),
             .multiply(let l, let r, _), .divide(let l, let r, _):
            try checkExpr(l, expectedType: .nat, context: context)
            try checkExpr(r, expectedType: .nat, context: context)
            return .nat

        // ---- Logic operators ----
        case .logicNot(let e, _):
            try checkExpr(e, expectedType: .bool, context: context)
            return .bool

        case .logicAnd(let l, let r, _), .logicOr(let l, let r, _):
            try checkExpr(l, expectedType: .bool, context: context)
            try checkExpr(r, expectedType: .bool, context: context)
            return .bool

        // ---- Comparison operators ----
        case .lessThan(let l, let r, _), .lessThanOrEqual(let l, let r, _),
             .greaterThan(let l, let r, _), .greaterThanOrEqual(let l, let r, _):
            try checkExpr(l, expectedType: .nat, context: context)
            try checkExpr(r, expectedType: .nat, context: context)
            return .bool

        case .equal(let l, let r, _), .notEqual(let l, let r, _):
            let leftType = try inferType(l, context: context)
            try checkExpr(r, expectedType: leftType, context: context)
            return .bool
        }
    }

    // MARK: - Subtyping

    /// Returns true if `s` is a subtype of `t` under the current subtyping rules.
    /// When `structuralSubtyping` is false, only reflexivity (s == t) applies.
    /// When true, the full structural subtype relation from TaPL §15 is used.
    private func isSubtype(_ s: Type, _ t: Type) -> Bool {
        // Reflexivity — always holds
        if s == t { return true }

        if !structuralSubtyping {
            return false
        }

        // Bot <: T for all T (Bot is the bottom type, never instantiated at runtime)
        if case .bot = s { return true }
        // T <: Top for all T (Top is the supertype of everything)
        if case .top = t { return true }

        switch (s, t) {
        // S-Arrow: (S1 → S2) <: (T1 → T2)  iff  T1 <: S1  and  S2 <: T2
        // Parameters are CONTRAVARIANT; return type is COVARIANT
        case (.function(let sParams, let sRet), .function(let tParams, let tRet)):
            guard sParams.count == tParams.count else { return false }
            let paramsOk = zip(sParams, tParams).allSatisfy { isSubtype($1, $0) }  // note reversed order
            return paramsOk && isSubtype(sRet, tRet)

        // S-RcdWidth/Depth: {li:Si,...} <: {lj:Tj} when all lj appear in {li} with Si <: Tj
        // A record with MORE fields is a subtype (the extra fields can be ignored by the consumer)
        case (.record(let sFields), .record(let tFields)):
            for tField in tFields {
                guard let sField = sFields.first(where: { $0.label == tField.label }) else {
                    return false  // required field missing
                }
                if !isSubtype(sField.fieldType, tField.fieldType) { return false }
            }
            return true

        // S-TupleDepth: {S1,...,Sn} <: {T1,...,Tn} when each Si <: Ti (positional)
        // Width subtyping: {S1,...,Sn,Sn+1,...} <: {T1,...,Sn} (can ignore extra elements)
        case (.tuple(let sTypes), .tuple(let tTypes)):
            guard sTypes.count >= tTypes.count else { return false }
            return zip(sTypes, tTypes).allSatisfy { isSubtype($0, $1) }

        // S-SumType: (S1 + S2) <: (T1 + T2) when S1 <: T1 and S2 <: T2 (covariant)
        case (.sum(let sL, let sR), .sum(let tL, let tR)):
            return isSubtype(sL, tL) && isSubtype(sR, tR)

        // S-List: [S] <: [T] when S <: T (covariant)
        case (.list(let sElem), .list(let tElem)):
            return isSubtype(sElem, tElem)

        // S-Variant: <|S-labels|> <: <|T-labels|> when S labels ⊆ T labels with Si <: Ti
        // A variant with FEWER labels is a subtype (every S value is also a valid T value)
        case (.variant(let sFields), .variant(let tFields)):
            for sField in sFields {
                guard let tField = tFields.first(where: { $0.label == sField.label }) else {
                    return false  // S has a label not present in T
                }
                switch (sField.fieldType, tField.fieldType) {
                case (nil, nil): break
                case (let st?, let tt?): if !isSubtype(st, tt) { return false }
                default: return false
                }
            }
            return true

        // S-Ref: &S <: &T iff S == T (references are INVARIANT — read and write)
        case (.ref(let sInner), .ref(let tInner)):
            return isSubtype(sInner, tInner) && isSubtype(tInner, sInner)

        default:
            return false
        }
    }

    // MARK: - Helper: expectType

    /// Checks that `found` is a subtype of (or equal to) `expected`.
    /// Raises the appropriate error if not.
    private func expectType(_ found: Type, toBeSubtypeOf expected: Type, expr: Expr) throws {
        if structuralSubtyping {
            if !isSubtype(found, expected) {
                throw TypeCheckError.errorUnexpectedSubtype(expected: expected, found: found, expr: expr)
            }
        } else {
            if found != expected {
                // Produce a specific error for variant label mismatches before the generic one
                if case .variant(let inferredFields) = found,
                   case .variant(let expectedFields) = expected {
                    let inferredLabels = Set(inferredFields.map { $0.label })
                    let expectedLabels = Set(expectedFields.map { $0.label })
                    let missing = expectedLabels.subtracting(inferredLabels)
                    if !missing.isEmpty {
                        throw TypeCheckError.errorMissingVariantLabels(
                            missing: Array(missing).sorted(), position: expr.position
                        )
                    }
                }
                throw TypeCheckError.errorUnexpectedTypeForExpression(
                    expected: expected, found: found, expr: expr
                )
            }
        }
    }

    // MARK: - Pattern Checking

    /// Validates that `pattern` is compatible with `type` and adds bound variables to `context`.
    private func checkPattern(_ pattern: Pattern, against type: Type, context: inout TypeContext) throws {
        switch (pattern, type) {
        case (.patternVar(let name, _), _):
            context[name] = type

        case (.patternTrue, .bool), (.patternFalse, .bool):
            break

        case (.patternUnit, .unit):
            break

        case (.patternInt(let n, let pos), .nat):
            if n < 0 { throw TypeCheckError.errorIllegalNegativeLiteral(position: pos) }

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
            case (nil, nil): break
            case (let pat?, let fieldType?):
                try checkPattern(pat, against: fieldType, context: &context)
            default:
                throw TypeCheckError.errorUnexpectedPatternForType(pattern: pattern, type: type)
            }

        case (.patternRecord(let labelledPatterns, _), .record(let fields)):
            for lp in labelledPatterns {
                guard let field = fields.first(where: { $0.label == lp.label }) else {
                    throw TypeCheckError.errorUnexpectedPatternForType(pattern: pattern, type: type)
                }
                try checkPattern(lp.pattern, against: field.fieldType, context: &context)
            }

        default:
            throw TypeCheckError.errorUnexpectedPatternForType(pattern: pattern, type: type)
        }
    }

    /// Helper: adds pattern variable bindings to `context` without type-compatibility checking
    /// (used for let/letrec where we already know the RHS type).
    private func bindPattern(_ pattern: Pattern, to type: Type, context: inout TypeContext) throws {
        if case .patternVar(let name, _) = pattern {
            context[name] = type
        } else {
            // For structural patterns in let bindings, delegate to checkPattern
            try checkPattern(pattern, against: type, context: &context)
        }
    }

    // MARK: - Exhaustiveness Checking

    /// Verifies that the `patterns` cover all cases for the given scrutinee `type`.
    private func checkExhaustiveness(patterns: [Pattern], against type: Type, position: SourcePosition) throws {
        switch type {
        case .sum:
            var hasInl = false, hasInr = false
            for p in patterns {
                switch p {
                case .patternInl: hasInl = true
                case .patternInr: hasInr = true
                case .patternVar: hasInl = true; hasInr = true  // wildcard
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
            for p in patterns {
                switch p {
                case .patternVariant(let label, _, _): coveredLabels.insert(label)
                case .patternVar: hasCatchAll = true
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
            var hasTrue = false, hasFalse = false
            for p in patterns {
                switch p {
                case .patternTrue: hasTrue = true
                case .patternFalse: hasFalse = true
                case .patternVar: hasTrue = true; hasFalse = true  // wildcard
                default: break
                }
            }
            if !hasTrue || !hasFalse {
                throw TypeCheckError.errorNonexhaustiveMatchPatterns(position: position)
            }

        default:
            // For Nat, list, etc. — a patternVar (wildcard) is accepted as exhaustive;
            // full coverage analysis for Nat/list would require infinite case enumeration.
            break
        }
    }

    // MARK: - Type Validation

    /// Recursively validates that a type is structurally well-formed
    /// (no duplicate record field names or variant labels).
    private func validateType(_ type: Type, at position: SourcePosition = .unknown) throws {
        switch type {
        case .record(let fields):
            let labels = fields.map { $0.label }
            let duplicates = findDuplicates(in: labels)
            if !duplicates.isEmpty {
                throw TypeCheckError.errorDuplicateRecordTypeFields(fields: duplicates, position: position)
            }
            for field in fields { try validateType(field.fieldType, at: position) }

        case .variant(let fields):
            let labels = fields.map { $0.label }
            let duplicates = findDuplicates(in: labels)
            if !duplicates.isEmpty {
                throw TypeCheckError.errorDuplicateVariantTypeFields(fields: duplicates, position: position)
            }
            for field in fields {
                if let ft = field.fieldType { try validateType(ft, at: position) }
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

        case .ref(let innerType):
            try validateType(innerType, at: position)

        case .bool, .nat, .unit, .top, .bot:
            break
        }
    }

    // MARK: - Helpers

    /// Returns sorted array of elements that appear more than once in `array`.
    private func findDuplicates(in array: [String]) -> [String] {
        var seen = Set<String>()
        var duplicates = Set<String>()
        for item in array {
            if seen.contains(item) { duplicates.insert(item) }
            seen.insert(item)
        }
        return Array(duplicates).sorted()
    }
}
