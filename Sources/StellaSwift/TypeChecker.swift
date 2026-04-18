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
    case errorExceptionTypeNotDeclared(position: SourcePosition)
    case errorAmbiguousThrowType(position: SourcePosition)
    case errorAmbiguousReferenceType(position: SourcePosition)
    case errorAmbiguousPanicType(position: SourcePosition)
    case errorNotAReference(expr: Expr, actualType: Type, position: SourcePosition)
    case errorUnexpectedMemoryAddress(expected: Type, position: SourcePosition)
    case errorUnexpectedReference(expected: Type, position: SourcePosition)
    case errorUnexpectedSubtype(expected: Type, found: Type, expr: Expr)

    // --- Stage 3 errors ---
    case errorOccursCheckInfiniteType(position: SourcePosition)
    case errorNotAGenericFunction(expr: Expr, actualType: Type, position: SourcePosition)
    case errorUndefinedTypeVariable(name: String, position: SourcePosition)
    case errorAmbiguousType(position: SourcePosition)
    case errorDuplicateTypeParameter(names: [String], position: SourcePosition)
    case errorIncorrectNumberOfTypeArguments(expected: Int, found: Int, position: SourcePosition)

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
        // Stage 3
        case .errorOccursCheckInfiniteType: return "ERROR_OCCURS_CHECK_INFINITE_TYPE"
        case .errorNotAGenericFunction: return "ERROR_NOT_A_GENERIC_FUNCTION"
        case .errorUndefinedTypeVariable: return "ERROR_UNDEFINED_TYPE_VARIABLE"
        case .errorAmbiguousType: return "ERROR_AMBIGUOUS_TYPE"
        case .errorDuplicateTypeParameter: return "ERROR_DUPLICATE_TYPE_PARAMETER"
        case .errorIncorrectNumberOfTypeArguments: return "ERROR_INCORRECT_NUMBER_OF_TYPE_ARGUMENTS"
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

        // --- Stage 3 error messages ---

        case .errorOccursCheckInfiniteType(let pos):
            return """
            \(code):
            Occurs check failed: unification would produce an infinite type
            at line \(pos.line), column \(pos.column)
            """

        case .errorNotAGenericFunction(let expr, let actualType, let pos):
            return """
            \(code):
            Attempting to apply type argument to a non-generic expression
            Expression: \(expr)
            Type: \(actualType)
            at line \(pos.line), column \(pos.column)
            """

        case .errorUndefinedTypeVariable(let name, let pos):
            return """
            \(code):
            Undefined type variable '\(name)'
            at line \(pos.line), column \(pos.column)
            """

        case .errorAmbiguousType(let pos):
            return """
            \(code):
            Ambiguous type variable remains where a concrete type is needed
            at line \(pos.line), column \(pos.column)
            """

        case .errorDuplicateTypeParameter(let names, let pos):
            return """
            \(code):
            Duplicate type parameter names: \(names.joined(separator: ", "))
            at line \(pos.line), column \(pos.column)
            """

        case .errorIncorrectNumberOfTypeArguments(let expected, let found, let pos):
            return """
            \(code):
            Incorrect number of type arguments: expected \(expected), found \(found)
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

    // --- Stage 2 flags ---
    private var structuralSubtyping: Bool = false
    private var ambiguousTypeAsBottom: Bool = false
    private var exceptionType: Type? = nil

    // --- Stage 3 flags ---
    // typeReconstruction: enabled by #type-reconstruction — all `auto` annotations become
    //   fresh type variables and types are inferred via unification (Hindley-Milner style).
    // universalTypes: enabled by #universal-types — System-F style parametric polymorphism
    //   with `generic fn`, `forall`, type abstractions, and type applications.
    private var typeReconstruction: Bool = false
    private var universalTypes: Bool = false

    // --- Stage 3: Type reconstruction state ---
    // substitution maps type-variable names (e.g. "?T3") to the types they've been unified with.
    // nextTypeVarId is the counter used to generate unique fresh variable names.
    private var substitution: [String: Type] = [:]
    private var nextTypeVarId: Int = 0

    // --- Stage 3: Universal types state ---
    // typeVarScope holds the names of type variables currently in lexical scope (from
    // enclosing generic fn / type-abstraction binders). Used to catch ERROR_UNDEFINED_TYPE_VARIABLE.
    private var typeVarScope: Set<String> = []

    // MARK: - Entry Point

    func typecheck(program: Program) throws {
        let allExtNames = program.extensions.flatMap { $0.names }
        structuralSubtyping   = allExtNames.contains("#structural-subtyping")
        ambiguousTypeAsBottom = allExtNames.contains("#ambiguous-type-as-bottom")
        typeReconstruction    = allExtNames.contains("#type-reconstruction")
        universalTypes        = allExtNames.contains("#universal-types")

        for decl in program.decls {
            if case .declExceptionType(let exType, _) = decl {
                exceptionType = exType
            }
        }

        // Stage 3 (#type-reconstruction): Before type-checking begins, walk the entire program
        // and replace every occurrence of the `auto` type with a globally-unique type variable
        // (e.g. ?T1, ?T2, …). The unification engine will then solve those variables as
        // constraints are discovered during type-checking.
        var processedDecls = program.decls
        if typeReconstruction {
            processedDecls = program.decls.map { replaceAutoInDecl($0) }
        }

        guard let mainDecl = processedDecls.first(where: { decl in
            switch decl {
            case .declFun(let name, _, _, _, _, _): return name == "main"
            case .declFunGeneric(let name, _, _, _, _, _, _): return name == "main"
            default: return false
            }
        }) else {
            throw TypeCheckError.errorMissingMain
        }

        try buildGlobalContext(from: processedDecls)

        switch mainDecl {
        case .declFun(_, let params, _, _, _, _):
            guard params.count == 1 else {
                throw TypeCheckError.errorIncorrectTypeOfMain
            }
        case .declFunGeneric(_, _, let params, _, _, _, _):
            guard params.count == 1 else {
                throw TypeCheckError.errorIncorrectTypeOfMain
            }
        default:
            throw TypeCheckError.errorIncorrectTypeOfMain
        }

        for decl in processedDecls {
            try typecheckDecl(decl)
        }
    }

    private func isDeclNamed(_ decl: Decl, name: String) -> Bool {
        switch decl {
        case .declFun(let n, _, _, _, _, _): return n == name
        case .declFunGeneric(let n, _, _, _, _, _, _): return n == name
        default: return false
        }
    }

    // MARK: - Global Context Construction

    private func buildGlobalContext(from decls: [Decl]) throws {
        for decl in decls {
            switch decl {
            case .declFun(let name, let params, let returnType, _, _, _):
                let paramTypes = params.map { $0.paramType }
                guard let retType = returnType else {
                    fatalError("Function \(name) must have explicit return type")
                }
                globalContext[name] = .function(paramTypes: paramTypes, returnType: retType)

            case .declFunGeneric(let name, let typeParams, let params, let returnType, _, _, _):
                let paramTypes = params.map { $0.paramType }
                guard let retType = returnType else {
                    fatalError("Generic function \(name) must have explicit return type")
                }
                let fnType = Type.function(paramTypes: paramTypes, returnType: retType)
                globalContext[name] = .forAll(typeVars: typeParams, bodyType: fnType)

            default:
                continue
            }
        }
    }

    // MARK: - Declaration Type Checking

    private func typecheckDecl(_ decl: Decl) throws {
        switch decl {
        case .declFun(let name, let params, let returnType, let localDecls, let returnExpr, let declPos):
            // Validate explicit types unless in reconstruction mode (auto types are handled later via unification)
            if universalTypes || !typeReconstruction {
                for param in params {
                    try validateType(param.paramType, at: declPos)
                }
                if let retType = returnType {
                    try validateType(retType, at: declPos)
                }
            }

            try typecheckFunctionBody(named: name, params: params, returnType: returnType,
                                       localDecls: localDecls, returnExpr: returnExpr)

        case .declFunGeneric(let name, let typeParams, let params, let returnType, let localDecls, let returnExpr, let declPos):
            // Bring type parameters into scope for the duration of this declaration
            let oldScope = typeVarScope
            typeVarScope = typeVarScope.union(typeParams)
            defer { typeVarScope = oldScope }

            let dupes = findDuplicates(in: typeParams)
            if !dupes.isEmpty {
                throw TypeCheckError.errorDuplicateTypeParameter(names: dupes, position: declPos)
            }

            for param in params {
                try validateType(param.paramType, at: declPos)
            }
            if let retType = returnType {
                try validateType(retType, at: declPos)
            }

            try typecheckFunctionBody(named: name, params: params, returnType: returnType,
                                       localDecls: localDecls, returnExpr: returnExpr)

        case .declExceptionType:
            break
        }
    }

    /// Builds a local type context from params + local decl signatures, type-checks
    /// all local declarations, then verifies the return expression against the declared return type.
    /// Shared by both regular (declFun) and generic (declFunGeneric) function checking.
    private func typecheckFunctionBody(
        named name: String,
        params: [ParamDecl],
        returnType: Type?,
        localDecls: [Decl],
        returnExpr: Expr
    ) throws {
        var localContext = globalContext
        for param in params {
            localContext[param.name] = param.paramType
        }

        // Register local function signatures so they can call each other recursively
        for localDecl in localDecls {
            if case .declFun(let localName, let localParams, let localRetType, _, _, _) = localDecl {
                let localParamTypes = localParams.map { $0.paramType }
                if let ret = localRetType {
                    localContext[localName] = .function(paramTypes: localParamTypes, returnType: ret)
                }
            }
            if case .declFunGeneric(let localName, let tParams, let localParams, let localRetType, _, _, _) = localDecl {
                let localParamTypes = localParams.map { $0.paramType }
                if let ret = localRetType {
                    localContext[localName] = .forAll(typeVars: tParams,
                                                      bodyType: .function(paramTypes: localParamTypes, returnType: ret))
                }
            }
        }

        for localDecl in localDecls {
            try typecheckDecl(localDecl)
        }

        guard let expectedReturnType = returnType else {
            fatalError("Function '\(name)' must have explicit return type")
        }
        try checkExpr(returnExpr, expectedType: expectedReturnType, context: localContext)
    }

    // MARK: - Checking Mode

    /// Checking mode (type-directed): verify that `expr` has type compatible with `expectedType`.
    /// In reconstruction mode the expected type is first fully resolved through the current
    /// substitution; if it is still a free type variable the expression is inferred instead and the
    /// variable is unified with the inferred type (constraint generation).
    private func checkExpr(_ expr: Expr, expectedType: Type, context: TypeContext) throws {
        let expected: Type
        if typeReconstruction {
            let resolved = resolveType(expectedType)
            if case .typeVar(_) = resolved {
                // Expected is still unknown — infer the expression and record the constraint
                let inferred = try inferType(expr, context: context)
                try unify(resolved, inferred, expr: expr)
                return
            }
            expected = resolved
        } else {
            expected = expectedType
        }

        switch (expr, expected) {

        // === Lambda against function type ===
        case (.abstraction(let params, let body, _), .function(let expectedParamTypes, let expectedReturnType)):
            guard params.count == expectedParamTypes.count else {
                throw TypeCheckError.errorUnexpectedTypeForExpression(
                    expected: expected,
                    found: .function(paramTypes: params.map { $0.paramType }, returnType: .nat),
                    expr: expr
                )
            }

            if typeReconstruction {
                for (param, expectedParamType) in zip(params, expectedParamTypes) {
                    try unify(param.paramType, expectedParamType, expr: expr)
                }
            } else if structuralSubtyping {
                for (param, expectedParamType) in zip(params, expectedParamTypes) {
                    if !isSubtype(expectedParamType, param.paramType) {
                        if case .record(let paramFields) = param.paramType,
                           case .record(_) = expectedParamType {
                            let expectedLabels = Set(expectedParamTypes.flatMap { t -> [String] in
                                if case .record(let fs) = t { return fs.map { $0.label } }
                                return []
                            })
                            let paramLabels = Set(paramFields.map { $0.label })
                            let missing = paramLabels.subtracting(expectedLabels)
                            if !missing.isEmpty {
                                throw TypeCheckError.errorMissingRecordFields(
                                    missing: Array(missing).sorted(), position: param.position
                                )
                            }
                        }
                        let inferredFnType = Type.function(
                            paramTypes: params.map { $0.paramType },
                            returnType: expectedReturnType
                        )
                        throw TypeCheckError.errorUnexpectedSubtype(
                            expected: expected, found: inferredFnType, expr: expr
                        )
                    }
                }
            } else {
                for (param, expectedParamType) in zip(params, expectedParamTypes) {
                    if param.paramType != expectedParamType {
                        throw TypeCheckError.errorUnexpectedTypeForParameter(
                            expected: expectedParamType,
                            found: param.paramType,
                            position: param.position
                        )
                    }
                }
            }

            var bodyContext = context
            for param in params {
                bodyContext[param.name] = param.paramType
            }
            try checkExpr(body, expectedType: expectedReturnType, context: bodyContext)

        // === Tuple against tuple type ===
        case (.tuple(let exprs, let pos), .tuple(let expectedTypes)):
            if structuralSubtyping {
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
        case (.record(let bindings, let pos), .record(let expectedFields)):
            let bindingNames = bindings.map { $0.name }
            let duplicates = findDuplicates(in: bindingNames)
            if !duplicates.isEmpty {
                throw TypeCheckError.errorDuplicateRecordFields(fields: duplicates, position: pos)
            }

            let providedLabels = Set(bindings.map { $0.name })
            let expectedLabels = Set(expectedFields.map { $0.label })

            if !structuralSubtyping {
                let unexpected = providedLabels.subtracting(expectedLabels)
                if !unexpected.isEmpty {
                    throw TypeCheckError.errorUnexpectedRecordFields(
                        unexpected: Array(unexpected).sorted(), position: pos
                    )
                }
            }

            let missing = expectedLabels.subtracting(providedLabels)
            if !missing.isEmpty {
                throw TypeCheckError.errorMissingRecordFields(
                    missing: Array(missing).sorted(), position: pos
                )
            }

            for binding in bindings {
                guard let expectedField = expectedFields.first(where: { $0.label == binding.name }) else {
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
                    label: label, variantType: expected, position: pos
                )
            }
            switch (exprOpt, field.fieldType) {
            case (nil, nil):
                break
            case (let innerExpr?, let fieldType?):
                try checkExpr(innerExpr, expectedType: fieldType, context: context)
            case (nil, _?):
                throw TypeCheckError.errorUnexpectedTypeForExpression(
                    expected: expected, found: expected, expr: expr
                )
            case (_?, nil):
                throw TypeCheckError.errorUnexpectedTypeForExpression(
                    expected: expected, found: expected, expr: expr
                )
            }

        // === panic! ===
        case (.panic_(_), _):
            break

        // === throw(e) ===
        case (.throw_(let innerExpr, let pos), _):
            guard let excType = exceptionType else {
                throw TypeCheckError.errorExceptionTypeNotDeclared(position: pos)
            }
            try checkExpr(innerExpr, expectedType: excType, context: context)

        // === new(e) against &T ===
        case (.newRef(let innerExpr, _), .ref(let innerType)):
            try checkExpr(innerExpr, expectedType: innerType, context: context)

        // === new(e) against a non-reference type ===
        case (.newRef(_, let pos), _):
            throw TypeCheckError.errorUnexpectedReference(expected: expected, position: pos)

        // === @address against &T ===
        case (.constMemory, .ref):
            break

        // === @address against a non-reference type ===
        case (.constMemory(_, let pos), _):
            throw TypeCheckError.errorUnexpectedMemoryAddress(expected: expected, position: pos)

        // === if-then-else ===
        case (.ifExpr(let condition, let thenExpr, let elseExpr, _), _):
            try checkExpr(condition, expectedType: .bool, context: context)
            try checkExpr(thenExpr, expectedType: expected, context: context)
            try checkExpr(elseExpr, expectedType: expected, context: context)

        // === let bindings ===
        case (.letExpr(let bindings, let body, _), _):
            var newContext = context
            for binding in bindings {
                let rhsType = try inferType(binding.rhs, context: newContext)
                try bindPattern(binding.pattern, to: rhsType, context: &newContext)
            }
            try checkExpr(body, expectedType: expected, context: newContext)

        // === match ===
        case (.match(let scrutinee, let cases, let pos), _):
            if cases.isEmpty {
                throw TypeCheckError.errorIllegalEmptyMatching(position: pos)
            }
            let scrutineeType = try inferType(scrutinee, context: context)
            let resolvedScrutineeType = typeReconstruction ? resolveType(scrutineeType) : scrutineeType
            for matchCase in cases {
                var caseContext = context
                try checkPattern(matchCase.pattern, against: resolvedScrutineeType, context: &caseContext)
                try checkExpr(matchCase.expr, expectedType: expected, context: caseContext)
            }
            try checkExhaustiveness(patterns: cases.map { $0.pattern }, against: resolvedScrutineeType, position: pos)

        // === parenthesised ===
        case (.parenthesised(let innerExpr, _), _):
            try checkExpr(innerExpr, expectedType: expected, context: context)

        // === dereference ===
        case (.deref(let innerExpr, _), _):
            try checkExpr(innerExpr, expectedType: .ref(expected), context: context)

        // === try-with ===
        case (.tryWith(let tryExpr, let fallback, _), _):
            try checkExpr(tryExpr, expectedType: expected, context: context)
            try checkExpr(fallback, expectedType: expected, context: context)

        // === try-catch ===
        case (.tryCatch(let tryExpr, let pat, let fallback, let pos), _):
            guard let excType = exceptionType else {
                throw TypeCheckError.errorExceptionTypeNotDeclared(position: pos)
            }
            try checkExpr(tryExpr, expectedType: expected, context: context)
            var catchContext = context
            try checkPattern(pat, against: excType, context: &catchContext)
            try checkExpr(fallback, expectedType: expected, context: catchContext)

        // === sequence ===
        case (.sequence(let e1, let e2, _), _):
            try checkExpr(e1, expectedType: .unit, context: context)
            try checkExpr(e2, expectedType: expected, context: context)

        // === Type abstraction (generic [X] body) checked against forall X. T ===
        // Rename expected bound variables to match actual binder names, then check the body.
        // If the same name was already in scope (shadowing), alpha-rename the outer occurrence
        // in the context so inner and outer variables stay distinct.
        case (.typeAbstraction(let typeVars, let body, _), .forAll(let expectedTypeVars, let expectedBodyType)):
            let oldScope = typeVarScope
            typeVarScope = typeVarScope.union(typeVars)
            defer { typeVarScope = oldScope }

            var mapping: [String: Type] = [:]
            for (tv, ev) in zip(typeVars, expectedTypeVars) {
                mapping[ev] = .typeVar(name: tv)
            }
            let renamedBodyType = substituteTypeVars(in: expectedBodyType, mapping: mapping)

            let shadowedVars = typeVars.filter { oldScope.contains($0) }
            var newContext = context
            if !shadowedVars.isEmpty {
                var outerRenaming: [String: Type] = [:]
                for sv in shadowedVars {
                    let fresh = "__outer_\(sv)_\(nextTypeVarId)"
                    nextTypeVarId += 1
                    outerRenaming[sv] = .typeVar(name: fresh)
                }
                for (key, value) in newContext {
                    newContext[key] = substituteTypeVars(in: value, mapping: outerRenaming)
                }
            }

            try checkExpr(body, expectedType: renamedBodyType, context: newContext)

        // === Structural mismatch errors ===
        // In reconstruction mode, infer and unify instead of throwing structural errors

        case (.abstraction(_, _, let pos), _):
            if typeReconstruction {
                let inferred = try inferType(expr, context: context)
                try unify(inferred, expected, expr: expr)
                return
            }
            throw TypeCheckError.errorUnexpectedLambda(expected: expected, position: pos)

        case (.tuple(_, let pos), _):
            if typeReconstruction {
                let inferred = try inferType(expr, context: context)
                try unify(inferred, expected, expr: expr)
                return
            }
            throw TypeCheckError.errorUnexpectedTuple(expected: expected, position: pos)

        case (.record(_, let pos), _):
            if typeReconstruction {
                let inferred = try inferType(expr, context: context)
                try unify(inferred, expected, expr: expr)
                return
            }
            throw TypeCheckError.errorUnexpectedRecord(expected: expected, position: pos)

        case (.inl(_, let pos), _):
            if typeReconstruction {
                let inferred = try inferType(expr, context: context)
                try unify(inferred, expected, expr: expr)
                return
            }
            throw TypeCheckError.errorUnexpectedInjection(expected: expected, position: pos)

        case (.inr(_, let pos), _):
            if typeReconstruction {
                let inferred = try inferType(expr, context: context)
                try unify(inferred, expected, expr: expr)
                return
            }
            throw TypeCheckError.errorUnexpectedInjection(expected: expected, position: pos)

        case (.list(_, let pos), _):
            if typeReconstruction {
                let inferred = try inferType(expr, context: context)
                try unify(inferred, expected, expr: expr)
                return
            }
            throw TypeCheckError.errorUnexpectedList(expected: expected, position: pos)

        case (.consList(_, _, let pos), _):
            if typeReconstruction {
                let inferred = try inferType(expr, context: context)
                try unify(inferred, expected, expr: expr)
                return
            }
            throw TypeCheckError.errorUnexpectedList(expected: expected, position: pos)

        case (.variant(_, _, let pos), _):
            if typeReconstruction {
                let inferred = try inferType(expr, context: context)
                try unify(inferred, expected, expr: expr)
                return
            }
            throw TypeCheckError.errorUnexpectedVariant(expected: expected, position: pos)

        // === Fallback: synthesize type and compare ===
        default:
            let inferredType = try inferType(expr, context: context)
            if typeReconstruction {
                try unify(inferredType, expected, expr: expr)
            } else {
                try expectType(inferredType, toBeSubtypeOf: expected, expr: expr)
            }
        }
    }

    // MARK: - Synthesis Mode

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
            var funType = try inferType(fun, context: context)

            if typeReconstruction {
                funType = resolveType(funType)
                if case .typeVar(_) = funType {
                    let freshParams = args.map { _ in freshTypeVar() }
                    let freshReturn = freshTypeVar()
                    try unify(funType, .function(paramTypes: freshParams, returnType: freshReturn), expr: fun)
                    for (arg, paramType) in zip(args, freshParams) {
                        try checkExpr(arg, expectedType: paramType, context: context)
                    }
                    return freshReturn
                }
            }

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
            var tupleType = try inferType(tupleExpr, context: context)
            if typeReconstruction {
                tupleType = resolveType(tupleType)
                if case .typeVar(_) = tupleType {
                    let tupleTypes = (0..<index).map { _ in freshTypeVar() }
                    try unify(tupleType, .tuple(tupleTypes), expr: tupleExpr)
                    return tupleTypes[index - 1]
                }
            }
            guard case .tuple(let types) = tupleType else {
                throw TypeCheckError.errorNotATuple(expr: tupleExpr, actualType: tupleType)
            }
            guard index >= 1 && index <= types.count else {
                throw TypeCheckError.errorTupleIndexOutOfBounds(
                    index: index, tupleSize: types.count, position: pos
                )
            }
            return types[index - 1]

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
            var recordType = try inferType(recordExpr, context: context)
            if typeReconstruction {
                recordType = resolveType(recordType)
                if case .typeVar(_) = recordType {
                    let fieldType = freshTypeVar()
                    try unify(recordType, .record([RecordFieldType(label: label, fieldType: fieldType)]), expr: recordExpr)
                    return fieldType
                }
            }
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
            if !typeReconstruction {
                try validateType(type, at: pos)
            }
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
            var newContext = context
            for binding in bindings {
                if case .abstraction(let params, _, _) = binding.rhs,
                   case .patternVar(let name, _) = binding.pattern {
                    let paramTypes = params.map { $0.paramType }
                    newContext[name] = .function(paramTypes: paramTypes, returnType: typeReconstruction ? freshTypeVar() : .bot)
                }
            }
            for binding in bindings {
                let rhsType = try inferType(binding.rhs, context: newContext)
                try bindPattern(binding.pattern, to: rhsType, context: &newContext)
            }
            return try inferType(body, context: newContext)

        // ---- Fixpoint ----
        case .fix(let f, _):
            var fType = try inferType(f, context: context)
            if typeReconstruction {
                fType = resolveType(fType)
                if case .typeVar(_) = fType {
                    let paramT = freshTypeVar()
                    let retT = freshTypeVar()
                    try unify(fType, .function(paramTypes: [paramT], returnType: retT), expr: f)
                    try unify(paramT, retT, expr: expr)
                    return resolveType(retT)
                }
            }
            guard case .function(let paramTypes, let returnType) = fType else {
                throw TypeCheckError.errorNotAFunction(expr: f, actualType: fType)
            }
            guard paramTypes.count == 1 else {
                throw TypeCheckError.errorUnexpectedTypeForExpression(
                    expected: .function(paramTypes: [returnType], returnType: returnType),
                    found: fType, expr: expr
                )
            }
            if typeReconstruction {
                try unify(paramTypes[0], returnType, expr: expr)
                return resolveType(returnType)
            }
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
                if typeReconstruction { return .list(freshTypeVar()) }
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
            var listType = try inferType(list, context: context)
            if typeReconstruction {
                listType = resolveType(listType)
                if case .typeVar(_) = listType {
                    let elemType = freshTypeVar()
                    try unify(listType, .list(elemType), expr: list)
                    return elemType
                }
            }
            guard case .list(let elemType) = listType else {
                throw TypeCheckError.errorNotAList(expr: list, actualType: listType)
            }
            return elemType

        case .tail(let list, _):
            var listType = try inferType(list, context: context)
            if typeReconstruction {
                listType = resolveType(listType)
                if case .typeVar(_) = listType {
                    let elemType = freshTypeVar()
                    try unify(listType, .list(elemType), expr: list)
                    return .list(elemType)
                }
            }
            guard case .list(_) = listType else {
                throw TypeCheckError.errorNotAList(expr: list, actualType: listType)
            }
            return listType

        case .isEmpty(let list, _):
            var listType = try inferType(list, context: context)
            if typeReconstruction {
                listType = resolveType(listType)
                if case .typeVar(_) = listType {
                    let elemType = freshTypeVar()
                    try unify(listType, .list(elemType), expr: list)
                    return .bool
                }
            }
            guard case .list(_) = listType else {
                throw TypeCheckError.errorNotAList(expr: list, actualType: listType)
            }
            return .bool

        // ---- Match ----
        case .match(let scrutinee, let cases, let pos):
            if cases.isEmpty { throw TypeCheckError.errorIllegalEmptyMatching(position: pos) }
            let scrutineeType = try inferType(scrutinee, context: context)
            let resolvedScrutineeType = typeReconstruction ? resolveType(scrutineeType) : scrutineeType

            let firstCase = cases[0]
            var firstContext = context
            try checkPattern(firstCase.pattern, against: resolvedScrutineeType, context: &firstContext)
            let resultType = try inferType(firstCase.expr, context: firstContext)

            for case_ in cases.dropFirst() {
                var caseContext = context
                try checkPattern(case_.pattern, against: resolvedScrutineeType, context: &caseContext)
                try checkExpr(case_.expr, expectedType: resultType, context: caseContext)
            }
            try checkExhaustiveness(patterns: cases.map { $0.pattern }, against: resolvedScrutineeType, position: pos)
            return resultType

        // ---- Sum types ----
        case .inl(let innerExpr, let pos):
            if typeReconstruction {
                let innerType = try inferType(innerExpr, context: context)
                return .sum(left: innerType, right: freshTypeVar())
            }
            if ambiguousTypeAsBottom {
                let innerType = try inferType(innerExpr, context: context)
                return .sum(left: innerType, right: .bot)
            }
            throw TypeCheckError.errorAmbiguousSumType(position: pos)

        case .inr(let innerExpr, let pos):
            if typeReconstruction {
                let innerType = try inferType(innerExpr, context: context)
                return .sum(left: freshTypeVar(), right: innerType)
            }
            if ambiguousTypeAsBottom {
                let innerType = try inferType(innerExpr, context: context)
                return .sum(left: .bot, right: innerType)
            }
            throw TypeCheckError.errorAmbiguousSumType(position: pos)

        // ---- Variants ----
        case .variant(_, _, let pos):
            throw TypeCheckError.errorAmbiguousVariantType(position: pos)

        // ---- Parenthesised ----
        case .parenthesised(let innerExpr, _):
            return try inferType(innerExpr, context: context)

        // ---- Sequencing ----
        case .sequence(let e1, let e2, _):
            try checkExpr(e1, expectedType: .unit, context: context)
            return try inferType(e2, context: context)

        // ---- References ----
        case .newRef(let innerExpr, _):
            let innerType = try inferType(innerExpr, context: context)
            return .ref(innerType)

        case .deref(let innerExpr, let pos):
            var innerType = try inferType(innerExpr, context: context)
            if typeReconstruction {
                innerType = resolveType(innerType)
                let refInner = freshTypeVar()
                try unify(innerType, .ref(refInner), expr: innerExpr)
                return resolveType(refInner)
            }
            guard case .ref(let refInnerType) = innerType else {
                throw TypeCheckError.errorNotAReference(expr: innerExpr, actualType: innerType, position: pos)
            }
            return refInnerType

        case .assign(let lhs, let rhs, let pos):
            var lhsType = try inferType(lhs, context: context)
            if typeReconstruction {
                lhsType = resolveType(lhsType)
                let refInner = freshTypeVar()
                try unify(lhsType, .ref(refInner), expr: lhs)
                try checkExpr(rhs, expectedType: refInner, context: context)
                return .unit
            }
            guard case .ref(let refInnerType) = lhsType else {
                throw TypeCheckError.errorNotAReference(expr: lhs, actualType: lhsType, position: pos)
            }
            try checkExpr(rhs, expectedType: refInnerType, context: context)
            return .unit

        case .constMemory(_, let pos):
            if typeReconstruction { return .ref(freshTypeVar()) }
            if ambiguousTypeAsBottom { return .ref(.bot) }
            throw TypeCheckError.errorAmbiguousReferenceType(position: pos)

        // ---- Panic ----
        case .panic_(let pos):
            if typeReconstruction { return freshTypeVar() }
            if ambiguousTypeAsBottom { return .bot }
            throw TypeCheckError.errorAmbiguousPanicType(position: pos)

        // ---- Exceptions ----
        case .throw_(let innerExpr, let pos):
            guard let excType = exceptionType else {
                throw TypeCheckError.errorExceptionTypeNotDeclared(position: pos)
            }
            try checkExpr(innerExpr, expectedType: excType, context: context)
            if typeReconstruction { return freshTypeVar() }
            if ambiguousTypeAsBottom { return .bot }
            throw TypeCheckError.errorAmbiguousThrowType(position: pos)

        case .tryWith(let tryExpr, let fallback, _):
            let tryType = try inferType(tryExpr, context: context)
            try checkExpr(fallback, expectedType: tryType, context: context)
            return tryType

        case .tryCatch(let tryExpr, let pat, let fallback, let pos):
            guard let excType = exceptionType else {
                throw TypeCheckError.errorExceptionTypeNotDeclared(position: pos)
            }
            let tryType = try inferType(tryExpr, context: context)
            var catchContext = context
            try checkPattern(pat, against: excType, context: &catchContext)
            try checkExpr(fallback, expectedType: tryType, context: catchContext)
            return tryType

        // ---- Type cast ----
        case .typeCast(let innerExpr, let type, let pos):
            try validateType(type, at: pos)
            _ = try inferType(innerExpr, context: context)
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

        // ---- Stage 3: Universal types (#universal-types) ----

        // generic [X] body  →  infer body type with X in scope, return forall X. bodyType
        case .typeAbstraction(let typeVars, let body, _):
            let oldScope = typeVarScope
            typeVarScope = typeVarScope.union(typeVars)
            defer { typeVarScope = oldScope }
            let bodyType = try inferType(body, context: context)
            return .forAll(typeVars: typeVars, bodyType: bodyType)

        // expr[T]  →  expr must have type forall X. S; substitute X := T throughout S
        // ERROR_NOT_A_GENERIC_FUNCTION is raised before inspecting the type argument.
        case .typeApplication(let innerExpr, let typeArgs, let pos):
            let innerType = try inferType(innerExpr, context: context)
            guard case .forAll(let typeParams, let bodyType) = innerType else {
                throw TypeCheckError.errorNotAGenericFunction(expr: innerExpr, actualType: innerType, position: pos)
            }
            guard typeArgs.count == typeParams.count else {
                throw TypeCheckError.errorIncorrectNumberOfTypeArguments(
                    expected: typeParams.count, found: typeArgs.count, position: pos
                )
            }
            for typeArg in typeArgs {
                try validateType(typeArg, at: pos)
            }
            var mapping: [String: Type] = [:]
            for (param, arg) in zip(typeParams, typeArgs) {
                mapping[param] = arg
            }
            // Capture-avoiding substitution is handled inside substituteTypeVars
            return substituteTypeVars(in: bodyType, mapping: mapping)
        }
    }

    // MARK: - Subtyping

    private func isSubtype(_ s: Type, _ t: Type) -> Bool {
        if s == t { return true }

        if !structuralSubtyping {
            return false
        }

        if case .bot = s { return true }
        if case .top = t { return true }

        switch (s, t) {
        case (.function(let sParams, let sRet), .function(let tParams, let tRet)):
            guard sParams.count == tParams.count else { return false }
            let paramsOk = zip(sParams, tParams).allSatisfy { isSubtype($1, $0) }
            return paramsOk && isSubtype(sRet, tRet)

        case (.record(let sFields), .record(let tFields)):
            for tField in tFields {
                guard let sField = sFields.first(where: { $0.label == tField.label }) else {
                    return false
                }
                if !isSubtype(sField.fieldType, tField.fieldType) { return false }
            }
            return true

        case (.tuple(let sTypes), .tuple(let tTypes)):
            guard sTypes.count >= tTypes.count else { return false }
            return zip(sTypes, tTypes).allSatisfy { isSubtype($0, $1) }

        case (.sum(let sL, let sR), .sum(let tL, let tR)):
            return isSubtype(sL, tL) && isSubtype(sR, tR)

        case (.list(let sElem), .list(let tElem)):
            return isSubtype(sElem, tElem)

        case (.variant(let sFields), .variant(let tFields)):
            for sField in sFields {
                guard let tField = tFields.first(where: { $0.label == sField.label }) else {
                    return false
                }
                switch (sField.fieldType, tField.fieldType) {
                case (nil, nil): break
                case (let st?, let tt?): if !isSubtype(st, tt) { return false }
                default: return false
                }
            }
            return true

        case (.ref(let sInner), .ref(let tInner)):
            return isSubtype(sInner, tInner) && isSubtype(tInner, sInner)

        default:
            return false
        }
    }

    // MARK: - Helper: expectType

    private func expectType(_ found: Type, toBeSubtypeOf expected: Type, expr: Expr) throws {
        if structuralSubtyping {
            if !isSubtype(found, expected) {
                throw TypeCheckError.errorUnexpectedSubtype(expected: expected, found: found, expr: expr)
            }
        } else {
            if found != expected {
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

    private func unifyForPattern(_ t1: Type, _ t2: Type, position: SourcePosition) throws {
        let r1 = resolveType(t1)
        let r2 = resolveType(t2)
        if r1 == r2 { return }
        let dummyExpr = Expr.constUnit(position)
        try unify(r1, r2, expr: dummyExpr)
    }

    private func checkPattern(_ pattern: Pattern, against type: Type, context: inout TypeContext) throws {
        let resolvedType = typeReconstruction ? resolveType(type) : type

        // In reconstruction mode, handle patterns against type variables via unification
        if typeReconstruction, case .typeVar(_) = resolvedType {
            switch pattern {
            case .patternVar(let name, _):
                context[name] = resolvedType
                return
            case .patternInl(let innerPattern, _):
                let leftType = freshTypeVar()
                let rightType = freshTypeVar()
                try unifyForPattern(resolvedType, .sum(left: leftType, right: rightType), position: pattern.position)
                try checkPattern(innerPattern, against: resolveType(leftType), context: &context)
                return
            case .patternInr(let innerPattern, _):
                let leftType = freshTypeVar()
                let rightType = freshTypeVar()
                try unifyForPattern(resolvedType, .sum(left: leftType, right: rightType), position: pattern.position)
                try checkPattern(innerPattern, against: resolveType(rightType), context: &context)
                return
            case .patternCons(let head, let tail, _):
                let elemType = freshTypeVar()
                try unifyForPattern(resolvedType, .list(elemType), position: pattern.position)
                let resolvedElem = resolveType(elemType)
                try checkPattern(head, against: resolvedElem, context: &context)
                try checkPattern(tail, against: .list(resolvedElem), context: &context)
                return
            case .patternList(let patterns, _):
                let elemType = freshTypeVar()
                try unifyForPattern(resolvedType, .list(elemType), position: pattern.position)
                let resolvedElem = resolveType(elemType)
                for pat in patterns {
                    try checkPattern(pat, against: resolvedElem, context: &context)
                }
                return
            case .patternTuple(let patterns, _):
                let types = patterns.map { _ in freshTypeVar() }
                try unifyForPattern(resolvedType, .tuple(types), position: pattern.position)
                for (pat, ty) in zip(patterns, types) {
                    try checkPattern(pat, against: resolveType(ty), context: &context)
                }
                return
            case .patternRecord(let labelledPatterns, _):
                let fieldTypes = labelledPatterns.map {
                    RecordFieldType(label: $0.label, fieldType: freshTypeVar())
                }
                try unifyForPattern(resolvedType, .record(fieldTypes), position: pattern.position)
                for (lp, ft) in zip(labelledPatterns, fieldTypes) {
                    try checkPattern(lp.pattern, against: resolveType(ft.fieldType), context: &context)
                }
                return
            case .patternTrue, .patternFalse:
                try unifyForPattern(resolvedType, .bool, position: pattern.position)
                return
            case .patternInt(let n, let pos):
                if n < 0 { throw TypeCheckError.errorIllegalNegativeLiteral(position: pos) }
                try unifyForPattern(resolvedType, .nat, position: pattern.position)
                return
            case .patternSucc(let innerPattern, _):
                try unifyForPattern(resolvedType, .nat, position: pattern.position)
                try checkPattern(innerPattern, against: .nat, context: &context)
                return
            case .patternUnit:
                try unifyForPattern(resolvedType, .unit, position: pattern.position)
                return
            default:
                break
            }
        }

        switch (pattern, resolvedType) {
        case (.patternVar(let name, _), _):
            context[name] = resolvedType

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
                throw TypeCheckError.errorUnexpectedPatternForType(pattern: pattern, type: resolvedType)
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
                throw TypeCheckError.errorUnexpectedPatternForType(pattern: pattern, type: resolvedType)
            }
            switch (innerPat, field.fieldType) {
            case (nil, nil): break
            case (let pat?, let fieldType?):
                try checkPattern(pat, against: fieldType, context: &context)
            default:
                throw TypeCheckError.errorUnexpectedPatternForType(pattern: pattern, type: resolvedType)
            }

        case (.patternRecord(let labelledPatterns, _), .record(let fields)):
            for lp in labelledPatterns {
                guard let field = fields.first(where: { $0.label == lp.label }) else {
                    throw TypeCheckError.errorUnexpectedPatternForType(pattern: pattern, type: resolvedType)
                }
                try checkPattern(lp.pattern, against: field.fieldType, context: &context)
            }

        default:
            throw TypeCheckError.errorUnexpectedPatternForType(pattern: pattern, type: resolvedType)
        }
    }

    private func bindPattern(_ pattern: Pattern, to type: Type, context: inout TypeContext) throws {
        if case .patternVar(let name, _) = pattern {
            context[name] = type
        } else {
            try checkPattern(pattern, against: type, context: &context)
        }
    }

    // MARK: - Exhaustiveness Checking

    private func checkExhaustiveness(patterns: [Pattern], against type: Type, position: SourcePosition) throws {
        let resolvedType = typeReconstruction ? resolveType(type) : type

        switch resolvedType {
        case .sum:
            var hasInl = false, hasInr = false
            for p in patterns {
                switch p {
                case .patternInl: hasInl = true
                case .patternInr: hasInr = true
                case .patternVar: hasInl = true; hasInr = true
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
                case .patternVar: hasTrue = true; hasFalse = true
                default: break
                }
            }
            if !hasTrue || !hasFalse {
                throw TypeCheckError.errorNonexhaustiveMatchPatterns(position: position)
            }

        default:
            break
        }
    }

    // MARK: - Type Validation

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

        case .typeVar(let name):
            if universalTypes && !typeVarScope.contains(name) {
                throw TypeCheckError.errorUndefinedTypeVariable(name: name, position: position)
            }

        case .forAll(let typeVars, let bodyType):
            let oldScope = typeVarScope
            typeVarScope = typeVarScope.union(typeVars)
            defer { typeVarScope = oldScope }
            try validateType(bodyType, at: position)

        case .bool, .nat, .unit, .top, .bot, .auto:
            break
        }
    }

    // MARK: - Stage 3: Type Reconstruction — Auto Replacement
    // These helpers implement the first pass of type reconstruction:
    // every `auto` annotation is replaced by a globally-unique fresh type variable
    // (e.g. ?T1, ?T2, …) that the unifier will later solve.

    /// Allocate a fresh type variable with a unique numeric suffix.
    private func freshTypeVar() -> Type {
        nextTypeVarId += 1
        return .typeVar(name: "?T\(nextTypeVarId)")
    }

    /// Replace every `auto` leaf in a type with a distinct fresh variable.
    private func replaceAutoInType(_ type: Type) -> Type {
        switch type {
        case .auto: return freshTypeVar()
        case .function(let ps, let r):
            return .function(paramTypes: ps.map(replaceAutoInType), returnType: replaceAutoInType(r))
        case .tuple(let ts): return .tuple(ts.map(replaceAutoInType))
        case .record(let fs):
            return .record(fs.map { RecordFieldType(label: $0.label, fieldType: replaceAutoInType($0.fieldType)) })
        case .sum(let l, let r): return .sum(left: replaceAutoInType(l), right: replaceAutoInType(r))
        case .list(let t): return .list(replaceAutoInType(t))
        case .variant(let fs):
            return .variant(fs.map { VariantFieldType(label: $0.label, fieldType: $0.fieldType.map(replaceAutoInType)) })
        case .ref(let t): return .ref(replaceAutoInType(t))
        case .forAll(let vs, let body): return .forAll(typeVars: vs, bodyType: replaceAutoInType(body))
        default: return type
        }
    }

    private func replaceAutoInDecl(_ decl: Decl) -> Decl {
        switch decl {
        case .declFun(let name, let params, let returnType, let localDecls, let returnExpr, let pos):
            return .declFun(
                name: name,
                paramDecls: params.map { ParamDecl(name: $0.name, paramType: replaceAutoInType($0.paramType), position: $0.position) },
                returnType: returnType.map(replaceAutoInType),
                localDecls: localDecls.map(replaceAutoInDecl),
                returnExpr: replaceAutoInExpr(returnExpr),
                position: pos
            )
        case .declFunGeneric(let name, let tps, let params, let returnType, let localDecls, let returnExpr, let pos):
            return .declFunGeneric(
                name: name,
                typeParams: tps,
                paramDecls: params.map { ParamDecl(name: $0.name, paramType: replaceAutoInType($0.paramType), position: $0.position) },
                returnType: returnType.map(replaceAutoInType),
                localDecls: localDecls.map(replaceAutoInDecl),
                returnExpr: replaceAutoInExpr(returnExpr),
                position: pos
            )
        case .declExceptionType:
            return decl
        }
    }

    private func replaceAutoInExpr(_ expr: Expr) -> Expr {
        switch expr {
        case .constTrue, .constFalse, .constInt, .constUnit, .variable, .constMemory, .panic_:
            return expr

        case .abstraction(let params, let body, let pos):
            return .abstraction(
                paramDecls: params.map { ParamDecl(name: $0.name, paramType: replaceAutoInType($0.paramType), position: $0.position) },
                returnExpr: replaceAutoInExpr(body), pos
            )

        case .application(let fun, let args, let pos):
            return .application(fun: replaceAutoInExpr(fun), args: args.map(replaceAutoInExpr), pos)

        case .ifExpr(let c, let t, let e, let pos):
            return .ifExpr(condition: replaceAutoInExpr(c), thenExpr: replaceAutoInExpr(t), elseExpr: replaceAutoInExpr(e), pos)

        case .succ(let n, let pos): return .succ(replaceAutoInExpr(n), pos)
        case .pred(let n, let pos): return .pred(replaceAutoInExpr(n), pos)
        case .isZero(let n, let pos): return .isZero(replaceAutoInExpr(n), pos)

        case .natRec(let n, let i, let s, let pos):
            return .natRec(n: replaceAutoInExpr(n), initial: replaceAutoInExpr(i), step: replaceAutoInExpr(s), pos)

        case .letExpr(let bindings, let body, let pos):
            let newBindings = bindings.map { PatternBinding(pattern: $0.pattern, rhs: replaceAutoInExpr($0.rhs)) }
            return .letExpr(bindings: newBindings, body: replaceAutoInExpr(body), pos)

        case .letRec(let bindings, let body, let pos):
            let newBindings = bindings.map { PatternBinding(pattern: $0.pattern, rhs: replaceAutoInExpr($0.rhs)) }
            return .letRec(bindings: newBindings, body: replaceAutoInExpr(body), pos)

        case .typeAsc(let e, let t, let pos):
            return .typeAsc(expr: replaceAutoInExpr(e), type: replaceAutoInType(t), pos)

        case .tuple(let exprs, let pos): return .tuple(exprs.map(replaceAutoInExpr), pos)
        case .dotTuple(let e, let idx, let pos): return .dotTuple(expr: replaceAutoInExpr(e), index: idx, pos)

        case .record(let bindings, let pos):
            return .record(bindings.map { Binding(name: $0.name, rhs: replaceAutoInExpr($0.rhs)) }, pos)
        case .dotRecord(let e, let label, let pos): return .dotRecord(expr: replaceAutoInExpr(e), label: label, pos)

        case .inl(let e, let pos): return .inl(replaceAutoInExpr(e), pos)
        case .inr(let e, let pos): return .inr(replaceAutoInExpr(e), pos)

        case .match(let scrutinee, let cases, let pos):
            return .match(
                expr: replaceAutoInExpr(scrutinee),
                cases: cases.map { MatchCase(pattern: $0.pattern, expr: replaceAutoInExpr($0.expr)) },
                pos
            )

        case .list(let exprs, let pos): return .list(exprs.map(replaceAutoInExpr), pos)
        case .consList(let h, let t, let pos): return .consList(head: replaceAutoInExpr(h), tail: replaceAutoInExpr(t), pos)
        case .head(let e, let pos): return .head(replaceAutoInExpr(e), pos)
        case .tail(let e, let pos): return .tail(replaceAutoInExpr(e), pos)
        case .isEmpty(let e, let pos): return .isEmpty(replaceAutoInExpr(e), pos)

        case .variant(let label, let e, let pos):
            return .variant(label: label, expr: e.map(replaceAutoInExpr), pos)

        case .fix(let e, let pos): return .fix(replaceAutoInExpr(e), pos)

        case .add(let l, let r, let pos): return .add(left: replaceAutoInExpr(l), right: replaceAutoInExpr(r), pos)
        case .subtract(let l, let r, let pos): return .subtract(left: replaceAutoInExpr(l), right: replaceAutoInExpr(r), pos)
        case .multiply(let l, let r, let pos): return .multiply(left: replaceAutoInExpr(l), right: replaceAutoInExpr(r), pos)
        case .divide(let l, let r, let pos): return .divide(left: replaceAutoInExpr(l), right: replaceAutoInExpr(r), pos)

        case .logicNot(let e, let pos): return .logicNot(replaceAutoInExpr(e), pos)
        case .logicAnd(let l, let r, let pos): return .logicAnd(left: replaceAutoInExpr(l), right: replaceAutoInExpr(r), pos)
        case .logicOr(let l, let r, let pos): return .logicOr(left: replaceAutoInExpr(l), right: replaceAutoInExpr(r), pos)

        case .lessThan(let l, let r, let pos): return .lessThan(left: replaceAutoInExpr(l), right: replaceAutoInExpr(r), pos)
        case .lessThanOrEqual(let l, let r, let pos): return .lessThanOrEqual(left: replaceAutoInExpr(l), right: replaceAutoInExpr(r), pos)
        case .greaterThan(let l, let r, let pos): return .greaterThan(left: replaceAutoInExpr(l), right: replaceAutoInExpr(r), pos)
        case .greaterThanOrEqual(let l, let r, let pos): return .greaterThanOrEqual(left: replaceAutoInExpr(l), right: replaceAutoInExpr(r), pos)
        case .equal(let l, let r, let pos): return .equal(left: replaceAutoInExpr(l), right: replaceAutoInExpr(r), pos)
        case .notEqual(let l, let r, let pos): return .notEqual(left: replaceAutoInExpr(l), right: replaceAutoInExpr(r), pos)

        case .sequence(let e1, let e2, let pos):
            return .sequence(expr1: replaceAutoInExpr(e1), expr2: replaceAutoInExpr(e2), pos)

        case .newRef(let e, let pos): return .newRef(replaceAutoInExpr(e), pos)
        case .deref(let e, let pos): return .deref(replaceAutoInExpr(e), pos)
        case .assign(let l, let r, let pos): return .assign(lhs: replaceAutoInExpr(l), rhs: replaceAutoInExpr(r), pos)

        case .throw_(let e, let pos): return .throw_(replaceAutoInExpr(e), pos)
        case .tryWith(let t, let f, let pos): return .tryWith(tryExpr: replaceAutoInExpr(t), fallbackExpr: replaceAutoInExpr(f), pos)
        case .tryCatch(let t, let p, let f, let pos):
            return .tryCatch(tryExpr: replaceAutoInExpr(t), pattern: p, fallbackExpr: replaceAutoInExpr(f), pos)

        case .typeCast(let e, let t, let pos): return .typeCast(expr: replaceAutoInExpr(e), type: replaceAutoInType(t), pos)
        case .parenthesised(let e, let pos): return .parenthesised(replaceAutoInExpr(e), pos)

        case .typeAbstraction(let tvs, let body, let pos):
            return .typeAbstraction(typeVars: tvs, body: replaceAutoInExpr(body), pos)
        case .typeApplication(let e, let ts, let pos):
            return .typeApplication(expr: replaceAutoInExpr(e), types: ts.map(replaceAutoInType), pos)
        }
    }

    // MARK: - Stage 3: Type Reconstruction — Unification
    // Standard union-find style unification.
    // resolveType  — walk the substitution chain to find a type's current representative.
    // occursIn     — occurs check; prevents unifying ?T with a type that mentions ?T (infinite type).
    // unify        — generate the most general unifier for two types, extending `substitution`.

    /// Follow the substitution chain for `type`, applying path compression along the way.
    private func resolveType(_ type: Type) -> Type {
        switch type {
        case .typeVar(let name):
            if let resolved = substitution[name] {
                let result = resolveType(resolved)
                substitution[name] = result
                return result
            }
            return type
        case .function(let params, let ret):
            return .function(paramTypes: params.map(resolveType), returnType: resolveType(ret))
        case .tuple(let types):
            return .tuple(types.map(resolveType))
        case .record(let fields):
            return .record(fields.map { RecordFieldType(label: $0.label, fieldType: resolveType($0.fieldType)) })
        case .sum(let l, let r):
            return .sum(left: resolveType(l), right: resolveType(r))
        case .list(let t):
            return .list(resolveType(t))
        case .variant(let fields):
            return .variant(fields.map { VariantFieldType(label: $0.label, fieldType: $0.fieldType.map(resolveType)) })
        case .ref(let t):
            return .ref(resolveType(t))
        case .forAll(let vs, let body):
            return .forAll(typeVars: vs, bodyType: resolveType(body))
        default:
            return type
        }
    }

    /// True if the free type variable `name` appears anywhere in `type` (after full resolution).
    private func occursIn(name: String, type: Type) -> Bool {
        let resolved = resolveType(type)
        switch resolved {
        case .typeVar(let n): return n == name
        case .function(let ps, let r): return ps.contains { occursIn(name: name, type: $0) } || occursIn(name: name, type: r)
        case .tuple(let ts): return ts.contains { occursIn(name: name, type: $0) }
        case .record(let fs): return fs.contains { occursIn(name: name, type: $0.fieldType) }
        case .sum(let l, let r): return occursIn(name: name, type: l) || occursIn(name: name, type: r)
        case .list(let t): return occursIn(name: name, type: t)
        case .variant(let fs): return fs.contains { f in f.fieldType.map { occursIn(name: name, type: $0) } ?? false }
        case .ref(let t): return occursIn(name: name, type: t)
        case .forAll(_, let body): return occursIn(name: name, type: body)
        default: return false
        }
    }

    /// Unify two types, extending the substitution.  Structural cases recurse; a type variable
    /// on either side is bound to the other type (after the occurs check).
    /// Raises ERROR_OCCURS_CHECK_INFINITE_TYPE when unification would produce an infinite type,
    /// and ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION when the two types are structurally incompatible.
    private func unify(_ t1: Type, _ t2: Type, expr: Expr) throws {
        let r1 = resolveType(t1)
        let r2 = resolveType(t2)

        if r1 == r2 { return }

        switch (r1, r2) {
        case (.typeVar(let name), _):
            if occursIn(name: name, type: r2) {
                throw TypeCheckError.errorOccursCheckInfiniteType(position: expr.position)
            }
            substitution[name] = r2

        case (_, .typeVar(let name)):
            if occursIn(name: name, type: r1) {
                throw TypeCheckError.errorOccursCheckInfiniteType(position: expr.position)
            }
            substitution[name] = r1

        case (.function(let p1, let ret1), .function(let p2, let ret2)):
            guard p1.count == p2.count else {
                throw TypeCheckError.errorUnexpectedTypeForExpression(expected: r2, found: r1, expr: expr)
            }
            for (a, b) in zip(p1, p2) {
                try unify(a, b, expr: expr)
            }
            try unify(ret1, ret2, expr: expr)

        case (.tuple(let ts1), .tuple(let ts2)):
            guard ts1.count == ts2.count else {
                throw TypeCheckError.errorUnexpectedTypeForExpression(expected: r2, found: r1, expr: expr)
            }
            for (a, b) in zip(ts1, ts2) {
                try unify(a, b, expr: expr)
            }

        case (.record(let fs1), .record(let fs2)):
            guard fs1.count == fs2.count else {
                throw TypeCheckError.errorUnexpectedTypeForExpression(expected: r2, found: r1, expr: expr)
            }
            let sorted1 = fs1.sorted { $0.label < $1.label }
            let sorted2 = fs2.sorted { $0.label < $1.label }
            for (f1, f2) in zip(sorted1, sorted2) {
                guard f1.label == f2.label else {
                    throw TypeCheckError.errorUnexpectedTypeForExpression(expected: r2, found: r1, expr: expr)
                }
                try unify(f1.fieldType, f2.fieldType, expr: expr)
            }

        case (.sum(let l1, let r1_), .sum(let l2, let r2_)):
            try unify(l1, l2, expr: expr)
            try unify(r1_, r2_, expr: expr)

        case (.list(let e1), .list(let e2)):
            try unify(e1, e2, expr: expr)

        case (.variant(let fs1), .variant(let fs2)):
            guard fs1.count == fs2.count else {
                throw TypeCheckError.errorUnexpectedTypeForExpression(expected: r2, found: r1, expr: expr)
            }
            for (f1, f2) in zip(fs1, fs2) {
                guard f1.label == f2.label else {
                    throw TypeCheckError.errorUnexpectedTypeForExpression(expected: r2, found: r1, expr: expr)
                }
                switch (f1.fieldType, f2.fieldType) {
                case (let t1?, let t2?): try unify(t1, t2, expr: expr)
                case (nil, nil): break
                default: throw TypeCheckError.errorUnexpectedTypeForExpression(expected: r2, found: r1, expr: expr)
                }
            }

        case (.ref(let t1_), .ref(let t2_)):
            try unify(t1_, t2_, expr: expr)

        case (.bool, .nat), (.nat, .bool),
             (.bool, .unit), (.unit, .bool),
             (.nat, .unit), (.unit, .nat):
            throw TypeCheckError.errorUnexpectedTypeForExpression(expected: r2, found: r1, expr: expr)

        default:
            throw TypeCheckError.errorUnexpectedTypeForExpression(expected: r2, found: r1, expr: expr)
        }
    }

    // MARK: - Stage 3: Universal Types — Type Substitution

    /// Substitute free type variables in `type` according to `mapping`.
    /// For `forAll` binders, bound variables shadow the mapping (not substituted),
    /// and capture-avoiding renaming is applied when a bound name would capture
    /// a free variable introduced by the substitution.
    private func substituteTypeVars(in type: Type, mapping: [String: Type]) -> Type {
        switch type {
        case .typeVar(let name):
            return mapping[name] ?? type
        case .function(let params, let ret):
            return .function(
                paramTypes: params.map { substituteTypeVars(in: $0, mapping: mapping) },
                returnType: substituteTypeVars(in: ret, mapping: mapping)
            )
        case .tuple(let types):
            return .tuple(types.map { substituteTypeVars(in: $0, mapping: mapping) })
        case .record(let fields):
            return .record(fields.map {
                RecordFieldType(label: $0.label, fieldType: substituteTypeVars(in: $0.fieldType, mapping: mapping))
            })
        case .sum(let left, let right):
            return .sum(
                left: substituteTypeVars(in: left, mapping: mapping),
                right: substituteTypeVars(in: right, mapping: mapping)
            )
        case .list(let elemType):
            return .list(substituteTypeVars(in: elemType, mapping: mapping))
        case .variant(let fields):
            return .variant(fields.map {
                VariantFieldType(label: $0.label, fieldType: $0.fieldType.map { substituteTypeVars(in: $0, mapping: mapping) })
            })
        case .ref(let innerType):
            return .ref(substituteTypeVars(in: innerType, mapping: mapping))
        case .forAll(let typeVars, let bodyType):
            var filteredMapping = mapping
            for tv in typeVars {
                filteredMapping.removeValue(forKey: tv)
            }
            // Capture-avoiding: check if any bound variable captures a free variable in substituted types
            let freeInSubstitution = Set(filteredMapping.values.flatMap { freeTypeVarsIn($0) })
            var renamedVars = typeVars
            var renaming: [String: Type] = [:]
            for (i, tv) in typeVars.enumerated() {
                if freeInSubstitution.contains(tv) {
                    let fresh = "__ca_\(tv)_\(nextTypeVarId)"
                    nextTypeVarId += 1
                    renamedVars[i] = fresh
                    renaming[tv] = .typeVar(name: fresh)
                }
            }
            var innerBody = bodyType
            if !renaming.isEmpty {
                innerBody = substituteTypeVars(in: innerBody, mapping: renaming)
            }
            return .forAll(typeVars: renamedVars, bodyType: substituteTypeVars(in: innerBody, mapping: filteredMapping))
        default:
            return type
        }
    }

    // MARK: - Helpers

    private func freeTypeVarsIn(_ type: Type) -> Set<String> {
        switch type {
        case .typeVar(let name):
            return [name]
        case .function(let params, let ret):
            return params.reduce(Set<String>()) { $0.union(freeTypeVarsIn($1)) }.union(freeTypeVarsIn(ret))
        case .tuple(let types):
            return types.reduce(Set<String>()) { $0.union(freeTypeVarsIn($1)) }
        case .record(let fields):
            return fields.reduce(Set<String>()) { $0.union(freeTypeVarsIn($1.fieldType)) }
        case .sum(let left, let right):
            return freeTypeVarsIn(left).union(freeTypeVarsIn(right))
        case .list(let elemType):
            return freeTypeVarsIn(elemType)
        case .variant(let fields):
            return fields.reduce(Set<String>()) { $0.union($1.fieldType.map { freeTypeVarsIn($0) } ?? []) }
        case .ref(let innerType):
            return freeTypeVarsIn(innerType)
        case .forAll(let typeVars, let bodyType):
            return freeTypeVarsIn(bodyType).subtracting(typeVars)
        default:
            return []
        }
    }

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
