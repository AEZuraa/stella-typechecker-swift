// Generated from stellaParser.g4 by ANTLR 4.13.2
import Antlr4

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link stellaParser}.
 */
public protocol stellaParserListener: ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link stellaParser#start_Program}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterStart_Program(_ ctx: stellaParser.Start_ProgramContext)
	/**
	 * Exit a parse tree produced by {@link stellaParser#start_Program}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitStart_Program(_ ctx: stellaParser.Start_ProgramContext)
	/**
	 * Enter a parse tree produced by {@link stellaParser#start_Expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterStart_Expr(_ ctx: stellaParser.Start_ExprContext)
	/**
	 * Exit a parse tree produced by {@link stellaParser#start_Expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitStart_Expr(_ ctx: stellaParser.Start_ExprContext)
	/**
	 * Enter a parse tree produced by {@link stellaParser#start_Type}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterStart_Type(_ ctx: stellaParser.Start_TypeContext)
	/**
	 * Exit a parse tree produced by {@link stellaParser#start_Type}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitStart_Type(_ ctx: stellaParser.Start_TypeContext)
	/**
	 * Enter a parse tree produced by {@link stellaParser#program}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterProgram(_ ctx: stellaParser.ProgramContext)
	/**
	 * Exit a parse tree produced by {@link stellaParser#program}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitProgram(_ ctx: stellaParser.ProgramContext)
	/**
	 * Enter a parse tree produced by the {@code LanguageCore}
	 * labeled alternative in {@link stellaParser#languageDecl}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterLanguageCore(_ ctx: stellaParser.LanguageCoreContext)
	/**
	 * Exit a parse tree produced by the {@code LanguageCore}
	 * labeled alternative in {@link stellaParser#languageDecl}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitLanguageCore(_ ctx: stellaParser.LanguageCoreContext)
	/**
	 * Enter a parse tree produced by the {@code AnExtension}
	 * labeled alternative in {@link stellaParser#extension}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAnExtension(_ ctx: stellaParser.AnExtensionContext)
	/**
	 * Exit a parse tree produced by the {@code AnExtension}
	 * labeled alternative in {@link stellaParser#extension}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAnExtension(_ ctx: stellaParser.AnExtensionContext)
	/**
	 * Enter a parse tree produced by the {@code DeclFun}
	 * labeled alternative in {@link stellaParser#decl}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDeclFun(_ ctx: stellaParser.DeclFunContext)
	/**
	 * Exit a parse tree produced by the {@code DeclFun}
	 * labeled alternative in {@link stellaParser#decl}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDeclFun(_ ctx: stellaParser.DeclFunContext)
	/**
	 * Enter a parse tree produced by the {@code DeclFunGeneric}
	 * labeled alternative in {@link stellaParser#decl}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDeclFunGeneric(_ ctx: stellaParser.DeclFunGenericContext)
	/**
	 * Exit a parse tree produced by the {@code DeclFunGeneric}
	 * labeled alternative in {@link stellaParser#decl}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDeclFunGeneric(_ ctx: stellaParser.DeclFunGenericContext)
	/**
	 * Enter a parse tree produced by the {@code DeclTypeAlias}
	 * labeled alternative in {@link stellaParser#decl}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDeclTypeAlias(_ ctx: stellaParser.DeclTypeAliasContext)
	/**
	 * Exit a parse tree produced by the {@code DeclTypeAlias}
	 * labeled alternative in {@link stellaParser#decl}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDeclTypeAlias(_ ctx: stellaParser.DeclTypeAliasContext)
	/**
	 * Enter a parse tree produced by the {@code DeclExceptionType}
	 * labeled alternative in {@link stellaParser#decl}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDeclExceptionType(_ ctx: stellaParser.DeclExceptionTypeContext)
	/**
	 * Exit a parse tree produced by the {@code DeclExceptionType}
	 * labeled alternative in {@link stellaParser#decl}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDeclExceptionType(_ ctx: stellaParser.DeclExceptionTypeContext)
	/**
	 * Enter a parse tree produced by the {@code DeclExceptionVariant}
	 * labeled alternative in {@link stellaParser#decl}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDeclExceptionVariant(_ ctx: stellaParser.DeclExceptionVariantContext)
	/**
	 * Exit a parse tree produced by the {@code DeclExceptionVariant}
	 * labeled alternative in {@link stellaParser#decl}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDeclExceptionVariant(_ ctx: stellaParser.DeclExceptionVariantContext)
	/**
	 * Enter a parse tree produced by the {@code InlineAnnotation}
	 * labeled alternative in {@link stellaParser#annotation}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterInlineAnnotation(_ ctx: stellaParser.InlineAnnotationContext)
	/**
	 * Exit a parse tree produced by the {@code InlineAnnotation}
	 * labeled alternative in {@link stellaParser#annotation}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitInlineAnnotation(_ ctx: stellaParser.InlineAnnotationContext)
	/**
	 * Enter a parse tree produced by {@link stellaParser#paramDecl}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterParamDecl(_ ctx: stellaParser.ParamDeclContext)
	/**
	 * Exit a parse tree produced by {@link stellaParser#paramDecl}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitParamDecl(_ ctx: stellaParser.ParamDeclContext)
	/**
	 * Enter a parse tree produced by the {@code Fold}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFold(_ ctx: stellaParser.FoldContext)
	/**
	 * Exit a parse tree produced by the {@code Fold}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFold(_ ctx: stellaParser.FoldContext)
	/**
	 * Enter a parse tree produced by the {@code Add}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAdd(_ ctx: stellaParser.AddContext)
	/**
	 * Exit a parse tree produced by the {@code Add}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAdd(_ ctx: stellaParser.AddContext)
	/**
	 * Enter a parse tree produced by the {@code IsZero}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterIsZero(_ ctx: stellaParser.IsZeroContext)
	/**
	 * Exit a parse tree produced by the {@code IsZero}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitIsZero(_ ctx: stellaParser.IsZeroContext)
	/**
	 * Enter a parse tree produced by the {@code Var}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterVar(_ ctx: stellaParser.VarContext)
	/**
	 * Exit a parse tree produced by the {@code Var}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitVar(_ ctx: stellaParser.VarContext)
	/**
	 * Enter a parse tree produced by the {@code TypeAbstraction}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeAbstraction(_ ctx: stellaParser.TypeAbstractionContext)
	/**
	 * Exit a parse tree produced by the {@code TypeAbstraction}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeAbstraction(_ ctx: stellaParser.TypeAbstractionContext)
	/**
	 * Enter a parse tree produced by the {@code Divide}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDivide(_ ctx: stellaParser.DivideContext)
	/**
	 * Exit a parse tree produced by the {@code Divide}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDivide(_ ctx: stellaParser.DivideContext)
	/**
	 * Enter a parse tree produced by the {@code LessThan}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterLessThan(_ ctx: stellaParser.LessThanContext)
	/**
	 * Exit a parse tree produced by the {@code LessThan}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitLessThan(_ ctx: stellaParser.LessThanContext)
	/**
	 * Enter a parse tree produced by the {@code DotRecord}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDotRecord(_ ctx: stellaParser.DotRecordContext)
	/**
	 * Exit a parse tree produced by the {@code DotRecord}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDotRecord(_ ctx: stellaParser.DotRecordContext)
	/**
	 * Enter a parse tree produced by the {@code GreaterThan}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterGreaterThan(_ ctx: stellaParser.GreaterThanContext)
	/**
	 * Exit a parse tree produced by the {@code GreaterThan}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitGreaterThan(_ ctx: stellaParser.GreaterThanContext)
	/**
	 * Enter a parse tree produced by the {@code Equal}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterEqual(_ ctx: stellaParser.EqualContext)
	/**
	 * Exit a parse tree produced by the {@code Equal}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitEqual(_ ctx: stellaParser.EqualContext)
	/**
	 * Enter a parse tree produced by the {@code Throw}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterThrow(_ ctx: stellaParser.ThrowContext)
	/**
	 * Exit a parse tree produced by the {@code Throw}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitThrow(_ ctx: stellaParser.ThrowContext)
	/**
	 * Enter a parse tree produced by the {@code Multiply}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterMultiply(_ ctx: stellaParser.MultiplyContext)
	/**
	 * Exit a parse tree produced by the {@code Multiply}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitMultiply(_ ctx: stellaParser.MultiplyContext)
	/**
	 * Enter a parse tree produced by the {@code ConstMemory}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterConstMemory(_ ctx: stellaParser.ConstMemoryContext)
	/**
	 * Exit a parse tree produced by the {@code ConstMemory}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitConstMemory(_ ctx: stellaParser.ConstMemoryContext)
	/**
	 * Enter a parse tree produced by the {@code List}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterList(_ ctx: stellaParser.ListContext)
	/**
	 * Exit a parse tree produced by the {@code List}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitList(_ ctx: stellaParser.ListContext)
	/**
	 * Enter a parse tree produced by the {@code TryCatch}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTryCatch(_ ctx: stellaParser.TryCatchContext)
	/**
	 * Exit a parse tree produced by the {@code TryCatch}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTryCatch(_ ctx: stellaParser.TryCatchContext)
	/**
	 * Enter a parse tree produced by the {@code TryCastAs}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTryCastAs(_ ctx: stellaParser.TryCastAsContext)
	/**
	 * Exit a parse tree produced by the {@code TryCastAs}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTryCastAs(_ ctx: stellaParser.TryCastAsContext)
	/**
	 * Enter a parse tree produced by the {@code Head}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterHead(_ ctx: stellaParser.HeadContext)
	/**
	 * Exit a parse tree produced by the {@code Head}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitHead(_ ctx: stellaParser.HeadContext)
	/**
	 * Enter a parse tree produced by the {@code TerminatingSemicolon}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTerminatingSemicolon(_ ctx: stellaParser.TerminatingSemicolonContext)
	/**
	 * Exit a parse tree produced by the {@code TerminatingSemicolon}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTerminatingSemicolon(_ ctx: stellaParser.TerminatingSemicolonContext)
	/**
	 * Enter a parse tree produced by the {@code NotEqual}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterNotEqual(_ ctx: stellaParser.NotEqualContext)
	/**
	 * Exit a parse tree produced by the {@code NotEqual}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitNotEqual(_ ctx: stellaParser.NotEqualContext)
	/**
	 * Enter a parse tree produced by the {@code ConstUnit}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterConstUnit(_ ctx: stellaParser.ConstUnitContext)
	/**
	 * Exit a parse tree produced by the {@code ConstUnit}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitConstUnit(_ ctx: stellaParser.ConstUnitContext)
	/**
	 * Enter a parse tree produced by the {@code Sequence}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterSequence(_ ctx: stellaParser.SequenceContext)
	/**
	 * Exit a parse tree produced by the {@code Sequence}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitSequence(_ ctx: stellaParser.SequenceContext)
	/**
	 * Enter a parse tree produced by the {@code ConstFalse}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterConstFalse(_ ctx: stellaParser.ConstFalseContext)
	/**
	 * Exit a parse tree produced by the {@code ConstFalse}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitConstFalse(_ ctx: stellaParser.ConstFalseContext)
	/**
	 * Enter a parse tree produced by the {@code Abstraction}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAbstraction(_ ctx: stellaParser.AbstractionContext)
	/**
	 * Exit a parse tree produced by the {@code Abstraction}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAbstraction(_ ctx: stellaParser.AbstractionContext)
	/**
	 * Enter a parse tree produced by the {@code ConstInt}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterConstInt(_ ctx: stellaParser.ConstIntContext)
	/**
	 * Exit a parse tree produced by the {@code ConstInt}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitConstInt(_ ctx: stellaParser.ConstIntContext)
	/**
	 * Enter a parse tree produced by the {@code Variant}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterVariant(_ ctx: stellaParser.VariantContext)
	/**
	 * Exit a parse tree produced by the {@code Variant}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitVariant(_ ctx: stellaParser.VariantContext)
	/**
	 * Enter a parse tree produced by the {@code ConstTrue}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterConstTrue(_ ctx: stellaParser.ConstTrueContext)
	/**
	 * Exit a parse tree produced by the {@code ConstTrue}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitConstTrue(_ ctx: stellaParser.ConstTrueContext)
	/**
	 * Enter a parse tree produced by the {@code Subtract}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterSubtract(_ ctx: stellaParser.SubtractContext)
	/**
	 * Exit a parse tree produced by the {@code Subtract}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitSubtract(_ ctx: stellaParser.SubtractContext)
	/**
	 * Enter a parse tree produced by the {@code TypeCast}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeCast(_ ctx: stellaParser.TypeCastContext)
	/**
	 * Exit a parse tree produced by the {@code TypeCast}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeCast(_ ctx: stellaParser.TypeCastContext)
	/**
	 * Enter a parse tree produced by the {@code If}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterIf(_ ctx: stellaParser.IfContext)
	/**
	 * Exit a parse tree produced by the {@code If}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitIf(_ ctx: stellaParser.IfContext)
	/**
	 * Enter a parse tree produced by the {@code Application}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterApplication(_ ctx: stellaParser.ApplicationContext)
	/**
	 * Exit a parse tree produced by the {@code Application}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitApplication(_ ctx: stellaParser.ApplicationContext)
	/**
	 * Enter a parse tree produced by the {@code Deref}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDeref(_ ctx: stellaParser.DerefContext)
	/**
	 * Exit a parse tree produced by the {@code Deref}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDeref(_ ctx: stellaParser.DerefContext)
	/**
	 * Enter a parse tree produced by the {@code IsEmpty}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterIsEmpty(_ ctx: stellaParser.IsEmptyContext)
	/**
	 * Exit a parse tree produced by the {@code IsEmpty}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitIsEmpty(_ ctx: stellaParser.IsEmptyContext)
	/**
	 * Enter a parse tree produced by the {@code Panic}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPanic(_ ctx: stellaParser.PanicContext)
	/**
	 * Exit a parse tree produced by the {@code Panic}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPanic(_ ctx: stellaParser.PanicContext)
	/**
	 * Enter a parse tree produced by the {@code LessThanOrEqual}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterLessThanOrEqual(_ ctx: stellaParser.LessThanOrEqualContext)
	/**
	 * Exit a parse tree produced by the {@code LessThanOrEqual}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitLessThanOrEqual(_ ctx: stellaParser.LessThanOrEqualContext)
	/**
	 * Enter a parse tree produced by the {@code Succ}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterSucc(_ ctx: stellaParser.SuccContext)
	/**
	 * Exit a parse tree produced by the {@code Succ}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitSucc(_ ctx: stellaParser.SuccContext)
	/**
	 * Enter a parse tree produced by the {@code Inl}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterInl(_ ctx: stellaParser.InlContext)
	/**
	 * Exit a parse tree produced by the {@code Inl}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitInl(_ ctx: stellaParser.InlContext)
	/**
	 * Enter a parse tree produced by the {@code GreaterThanOrEqual}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterGreaterThanOrEqual(_ ctx: stellaParser.GreaterThanOrEqualContext)
	/**
	 * Exit a parse tree produced by the {@code GreaterThanOrEqual}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitGreaterThanOrEqual(_ ctx: stellaParser.GreaterThanOrEqualContext)
	/**
	 * Enter a parse tree produced by the {@code Inr}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterInr(_ ctx: stellaParser.InrContext)
	/**
	 * Exit a parse tree produced by the {@code Inr}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitInr(_ ctx: stellaParser.InrContext)
	/**
	 * Enter a parse tree produced by the {@code Match}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterMatch(_ ctx: stellaParser.MatchContext)
	/**
	 * Exit a parse tree produced by the {@code Match}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitMatch(_ ctx: stellaParser.MatchContext)
	/**
	 * Enter a parse tree produced by the {@code LogicNot}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterLogicNot(_ ctx: stellaParser.LogicNotContext)
	/**
	 * Exit a parse tree produced by the {@code LogicNot}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitLogicNot(_ ctx: stellaParser.LogicNotContext)
	/**
	 * Enter a parse tree produced by the {@code ParenthesisedExpr}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterParenthesisedExpr(_ ctx: stellaParser.ParenthesisedExprContext)
	/**
	 * Exit a parse tree produced by the {@code ParenthesisedExpr}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitParenthesisedExpr(_ ctx: stellaParser.ParenthesisedExprContext)
	/**
	 * Enter a parse tree produced by the {@code Tail}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTail(_ ctx: stellaParser.TailContext)
	/**
	 * Exit a parse tree produced by the {@code Tail}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTail(_ ctx: stellaParser.TailContext)
	/**
	 * Enter a parse tree produced by the {@code Record}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterRecord(_ ctx: stellaParser.RecordContext)
	/**
	 * Exit a parse tree produced by the {@code Record}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitRecord(_ ctx: stellaParser.RecordContext)
	/**
	 * Enter a parse tree produced by the {@code LogicAnd}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterLogicAnd(_ ctx: stellaParser.LogicAndContext)
	/**
	 * Exit a parse tree produced by the {@code LogicAnd}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitLogicAnd(_ ctx: stellaParser.LogicAndContext)
	/**
	 * Enter a parse tree produced by the {@code TypeApplication}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeApplication(_ ctx: stellaParser.TypeApplicationContext)
	/**
	 * Exit a parse tree produced by the {@code TypeApplication}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeApplication(_ ctx: stellaParser.TypeApplicationContext)
	/**
	 * Enter a parse tree produced by the {@code LetRec}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterLetRec(_ ctx: stellaParser.LetRecContext)
	/**
	 * Exit a parse tree produced by the {@code LetRec}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitLetRec(_ ctx: stellaParser.LetRecContext)
	/**
	 * Enter a parse tree produced by the {@code LogicOr}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterLogicOr(_ ctx: stellaParser.LogicOrContext)
	/**
	 * Exit a parse tree produced by the {@code LogicOr}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitLogicOr(_ ctx: stellaParser.LogicOrContext)
	/**
	 * Enter a parse tree produced by the {@code TryWith}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTryWith(_ ctx: stellaParser.TryWithContext)
	/**
	 * Exit a parse tree produced by the {@code TryWith}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTryWith(_ ctx: stellaParser.TryWithContext)
	/**
	 * Enter a parse tree produced by the {@code Pred}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPred(_ ctx: stellaParser.PredContext)
	/**
	 * Exit a parse tree produced by the {@code Pred}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPred(_ ctx: stellaParser.PredContext)
	/**
	 * Enter a parse tree produced by the {@code TypeAsc}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeAsc(_ ctx: stellaParser.TypeAscContext)
	/**
	 * Exit a parse tree produced by the {@code TypeAsc}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeAsc(_ ctx: stellaParser.TypeAscContext)
	/**
	 * Enter a parse tree produced by the {@code NatRec}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterNatRec(_ ctx: stellaParser.NatRecContext)
	/**
	 * Exit a parse tree produced by the {@code NatRec}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitNatRec(_ ctx: stellaParser.NatRecContext)
	/**
	 * Enter a parse tree produced by the {@code Unfold}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterUnfold(_ ctx: stellaParser.UnfoldContext)
	/**
	 * Exit a parse tree produced by the {@code Unfold}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitUnfold(_ ctx: stellaParser.UnfoldContext)
	/**
	 * Enter a parse tree produced by the {@code Ref}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterRef(_ ctx: stellaParser.RefContext)
	/**
	 * Exit a parse tree produced by the {@code Ref}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitRef(_ ctx: stellaParser.RefContext)
	/**
	 * Enter a parse tree produced by the {@code DotTuple}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDotTuple(_ ctx: stellaParser.DotTupleContext)
	/**
	 * Exit a parse tree produced by the {@code DotTuple}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDotTuple(_ ctx: stellaParser.DotTupleContext)
	/**
	 * Enter a parse tree produced by the {@code Fix}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFix(_ ctx: stellaParser.FixContext)
	/**
	 * Exit a parse tree produced by the {@code Fix}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFix(_ ctx: stellaParser.FixContext)
	/**
	 * Enter a parse tree produced by the {@code Let}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterLet(_ ctx: stellaParser.LetContext)
	/**
	 * Exit a parse tree produced by the {@code Let}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitLet(_ ctx: stellaParser.LetContext)
	/**
	 * Enter a parse tree produced by the {@code Assign}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAssign(_ ctx: stellaParser.AssignContext)
	/**
	 * Exit a parse tree produced by the {@code Assign}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAssign(_ ctx: stellaParser.AssignContext)
	/**
	 * Enter a parse tree produced by the {@code Tuple}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTuple(_ ctx: stellaParser.TupleContext)
	/**
	 * Exit a parse tree produced by the {@code Tuple}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTuple(_ ctx: stellaParser.TupleContext)
	/**
	 * Enter a parse tree produced by the {@code ConsList}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterConsList(_ ctx: stellaParser.ConsListContext)
	/**
	 * Exit a parse tree produced by the {@code ConsList}
	 * labeled alternative in {@link stellaParser#expr}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitConsList(_ ctx: stellaParser.ConsListContext)
	/**
	 * Enter a parse tree produced by {@link stellaParser#patternBinding}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPatternBinding(_ ctx: stellaParser.PatternBindingContext)
	/**
	 * Exit a parse tree produced by {@link stellaParser#patternBinding}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPatternBinding(_ ctx: stellaParser.PatternBindingContext)
	/**
	 * Enter a parse tree produced by {@link stellaParser#binding}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterBinding(_ ctx: stellaParser.BindingContext)
	/**
	 * Exit a parse tree produced by {@link stellaParser#binding}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitBinding(_ ctx: stellaParser.BindingContext)
	/**
	 * Enter a parse tree produced by {@link stellaParser#matchCase}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterMatchCase(_ ctx: stellaParser.MatchCaseContext)
	/**
	 * Exit a parse tree produced by {@link stellaParser#matchCase}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitMatchCase(_ ctx: stellaParser.MatchCaseContext)
	/**
	 * Enter a parse tree produced by the {@code PatternCons}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPatternCons(_ ctx: stellaParser.PatternConsContext)
	/**
	 * Exit a parse tree produced by the {@code PatternCons}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPatternCons(_ ctx: stellaParser.PatternConsContext)
	/**
	 * Enter a parse tree produced by the {@code PatternTuple}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPatternTuple(_ ctx: stellaParser.PatternTupleContext)
	/**
	 * Exit a parse tree produced by the {@code PatternTuple}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPatternTuple(_ ctx: stellaParser.PatternTupleContext)
	/**
	 * Enter a parse tree produced by the {@code PatternList}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPatternList(_ ctx: stellaParser.PatternListContext)
	/**
	 * Exit a parse tree produced by the {@code PatternList}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPatternList(_ ctx: stellaParser.PatternListContext)
	/**
	 * Enter a parse tree produced by the {@code PatternRecord}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPatternRecord(_ ctx: stellaParser.PatternRecordContext)
	/**
	 * Exit a parse tree produced by the {@code PatternRecord}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPatternRecord(_ ctx: stellaParser.PatternRecordContext)
	/**
	 * Enter a parse tree produced by the {@code PatternVariant}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPatternVariant(_ ctx: stellaParser.PatternVariantContext)
	/**
	 * Exit a parse tree produced by the {@code PatternVariant}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPatternVariant(_ ctx: stellaParser.PatternVariantContext)
	/**
	 * Enter a parse tree produced by the {@code PatternAsc}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPatternAsc(_ ctx: stellaParser.PatternAscContext)
	/**
	 * Exit a parse tree produced by the {@code PatternAsc}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPatternAsc(_ ctx: stellaParser.PatternAscContext)
	/**
	 * Enter a parse tree produced by the {@code PatternInt}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPatternInt(_ ctx: stellaParser.PatternIntContext)
	/**
	 * Exit a parse tree produced by the {@code PatternInt}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPatternInt(_ ctx: stellaParser.PatternIntContext)
	/**
	 * Enter a parse tree produced by the {@code PatternInr}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPatternInr(_ ctx: stellaParser.PatternInrContext)
	/**
	 * Exit a parse tree produced by the {@code PatternInr}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPatternInr(_ ctx: stellaParser.PatternInrContext)
	/**
	 * Enter a parse tree produced by the {@code PatternTrue}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPatternTrue(_ ctx: stellaParser.PatternTrueContext)
	/**
	 * Exit a parse tree produced by the {@code PatternTrue}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPatternTrue(_ ctx: stellaParser.PatternTrueContext)
	/**
	 * Enter a parse tree produced by the {@code PatternInl}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPatternInl(_ ctx: stellaParser.PatternInlContext)
	/**
	 * Exit a parse tree produced by the {@code PatternInl}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPatternInl(_ ctx: stellaParser.PatternInlContext)
	/**
	 * Enter a parse tree produced by the {@code PatternVar}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPatternVar(_ ctx: stellaParser.PatternVarContext)
	/**
	 * Exit a parse tree produced by the {@code PatternVar}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPatternVar(_ ctx: stellaParser.PatternVarContext)
	/**
	 * Enter a parse tree produced by the {@code ParenthesisedPattern}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterParenthesisedPattern(_ ctx: stellaParser.ParenthesisedPatternContext)
	/**
	 * Exit a parse tree produced by the {@code ParenthesisedPattern}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitParenthesisedPattern(_ ctx: stellaParser.ParenthesisedPatternContext)
	/**
	 * Enter a parse tree produced by the {@code PatternSucc}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPatternSucc(_ ctx: stellaParser.PatternSuccContext)
	/**
	 * Exit a parse tree produced by the {@code PatternSucc}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPatternSucc(_ ctx: stellaParser.PatternSuccContext)
	/**
	 * Enter a parse tree produced by the {@code PatternFalse}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPatternFalse(_ ctx: stellaParser.PatternFalseContext)
	/**
	 * Exit a parse tree produced by the {@code PatternFalse}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPatternFalse(_ ctx: stellaParser.PatternFalseContext)
	/**
	 * Enter a parse tree produced by the {@code PatternUnit}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPatternUnit(_ ctx: stellaParser.PatternUnitContext)
	/**
	 * Exit a parse tree produced by the {@code PatternUnit}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPatternUnit(_ ctx: stellaParser.PatternUnitContext)
	/**
	 * Enter a parse tree produced by the {@code PatternCastAs}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPatternCastAs(_ ctx: stellaParser.PatternCastAsContext)
	/**
	 * Exit a parse tree produced by the {@code PatternCastAs}
	 * labeled alternative in {@link stellaParser#pattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPatternCastAs(_ ctx: stellaParser.PatternCastAsContext)
	/**
	 * Enter a parse tree produced by {@link stellaParser#labelledPattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterLabelledPattern(_ ctx: stellaParser.LabelledPatternContext)
	/**
	 * Exit a parse tree produced by {@link stellaParser#labelledPattern}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitLabelledPattern(_ ctx: stellaParser.LabelledPatternContext)
	/**
	 * Enter a parse tree produced by the {@code TypeTuple}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeTuple(_ ctx: stellaParser.TypeTupleContext)
	/**
	 * Exit a parse tree produced by the {@code TypeTuple}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeTuple(_ ctx: stellaParser.TypeTupleContext)
	/**
	 * Enter a parse tree produced by the {@code TypeTop}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeTop(_ ctx: stellaParser.TypeTopContext)
	/**
	 * Exit a parse tree produced by the {@code TypeTop}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeTop(_ ctx: stellaParser.TypeTopContext)
	/**
	 * Enter a parse tree produced by the {@code TypeBool}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeBool(_ ctx: stellaParser.TypeBoolContext)
	/**
	 * Exit a parse tree produced by the {@code TypeBool}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeBool(_ ctx: stellaParser.TypeBoolContext)
	/**
	 * Enter a parse tree produced by the {@code TypeRef}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeRef(_ ctx: stellaParser.TypeRefContext)
	/**
	 * Exit a parse tree produced by the {@code TypeRef}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeRef(_ ctx: stellaParser.TypeRefContext)
	/**
	 * Enter a parse tree produced by the {@code TypeRec}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeRec(_ ctx: stellaParser.TypeRecContext)
	/**
	 * Exit a parse tree produced by the {@code TypeRec}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeRec(_ ctx: stellaParser.TypeRecContext)
	/**
	 * Enter a parse tree produced by the {@code TypeAuto}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeAuto(_ ctx: stellaParser.TypeAutoContext)
	/**
	 * Exit a parse tree produced by the {@code TypeAuto}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeAuto(_ ctx: stellaParser.TypeAutoContext)
	/**
	 * Enter a parse tree produced by the {@code TypeSum}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeSum(_ ctx: stellaParser.TypeSumContext)
	/**
	 * Exit a parse tree produced by the {@code TypeSum}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeSum(_ ctx: stellaParser.TypeSumContext)
	/**
	 * Enter a parse tree produced by the {@code TypeVar}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeVar(_ ctx: stellaParser.TypeVarContext)
	/**
	 * Exit a parse tree produced by the {@code TypeVar}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeVar(_ ctx: stellaParser.TypeVarContext)
	/**
	 * Enter a parse tree produced by the {@code TypeVariant}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeVariant(_ ctx: stellaParser.TypeVariantContext)
	/**
	 * Exit a parse tree produced by the {@code TypeVariant}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeVariant(_ ctx: stellaParser.TypeVariantContext)
	/**
	 * Enter a parse tree produced by the {@code TypeUnit}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeUnit(_ ctx: stellaParser.TypeUnitContext)
	/**
	 * Exit a parse tree produced by the {@code TypeUnit}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeUnit(_ ctx: stellaParser.TypeUnitContext)
	/**
	 * Enter a parse tree produced by the {@code TypeNat}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeNat(_ ctx: stellaParser.TypeNatContext)
	/**
	 * Exit a parse tree produced by the {@code TypeNat}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeNat(_ ctx: stellaParser.TypeNatContext)
	/**
	 * Enter a parse tree produced by the {@code TypeBottom}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeBottom(_ ctx: stellaParser.TypeBottomContext)
	/**
	 * Exit a parse tree produced by the {@code TypeBottom}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeBottom(_ ctx: stellaParser.TypeBottomContext)
	/**
	 * Enter a parse tree produced by the {@code TypeParens}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeParens(_ ctx: stellaParser.TypeParensContext)
	/**
	 * Exit a parse tree produced by the {@code TypeParens}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeParens(_ ctx: stellaParser.TypeParensContext)
	/**
	 * Enter a parse tree produced by the {@code TypeFun}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeFun(_ ctx: stellaParser.TypeFunContext)
	/**
	 * Exit a parse tree produced by the {@code TypeFun}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeFun(_ ctx: stellaParser.TypeFunContext)
	/**
	 * Enter a parse tree produced by the {@code TypeForAll}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeForAll(_ ctx: stellaParser.TypeForAllContext)
	/**
	 * Exit a parse tree produced by the {@code TypeForAll}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeForAll(_ ctx: stellaParser.TypeForAllContext)
	/**
	 * Enter a parse tree produced by the {@code TypeRecord}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeRecord(_ ctx: stellaParser.TypeRecordContext)
	/**
	 * Exit a parse tree produced by the {@code TypeRecord}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeRecord(_ ctx: stellaParser.TypeRecordContext)
	/**
	 * Enter a parse tree produced by the {@code TypeList}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeList(_ ctx: stellaParser.TypeListContext)
	/**
	 * Exit a parse tree produced by the {@code TypeList}
	 * labeled alternative in {@link stellaParser#stellatype}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeList(_ ctx: stellaParser.TypeListContext)
	/**
	 * Enter a parse tree produced by {@link stellaParser#recordFieldType}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterRecordFieldType(_ ctx: stellaParser.RecordFieldTypeContext)
	/**
	 * Exit a parse tree produced by {@link stellaParser#recordFieldType}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitRecordFieldType(_ ctx: stellaParser.RecordFieldTypeContext)
	/**
	 * Enter a parse tree produced by {@link stellaParser#variantFieldType}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterVariantFieldType(_ ctx: stellaParser.VariantFieldTypeContext)
	/**
	 * Exit a parse tree produced by {@link stellaParser#variantFieldType}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitVariantFieldType(_ ctx: stellaParser.VariantFieldTypeContext)
}