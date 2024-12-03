# Generated by `ast-generator`, do not edit by hand.

from .prelude import *

class AssocItem(AstNode):
   pass

class Expr(AstNode):
   pass

class ExternItem(AstNode):
   pass

class FieldList(AstNode):
   pass

class GenericArg(AstNode):
   pass

class GenericParam(AstNode):
   pass

class Pat(AstNode):
   pass

class Stmt(AstNode):
   pass

class TypeRepr(AstNode):
   pass

class Item(Stmt):
   pass

class Abi(AstNode):
   abi_string: optional[string]

class ArgList(AstNode):
   args: list["Expr"] | child

class ArrayExpr(Expr):
   attrs: list["Attr"] | child
   exprs: list["Expr"] | child

class ArrayTypeRepr(TypeRepr):
   const_arg: optional["ConstArg"] | child
   element_type_repr: optional["TypeRepr"] | child

class AsmExpr(Expr):
   attrs: list["Attr"] | child
   expr: optional["Expr"] | child

class AssocItemList(AstNode):
   assoc_items: list["AssocItem"] | child
   attrs: list["Attr"] | child

class AssocTypeArg(GenericArg):
   const_arg: optional["ConstArg"] | child
   generic_arg_list: optional["GenericArgList"] | child
   name_ref: optional["NameRef"] | child
   param_list: optional["ParamList"] | child
   ret_type: optional["RetTypeRepr"] | child
   return_type_syntax: optional["ReturnTypeSyntax"] | child
   type_repr: optional["TypeRepr"] | child
   type_bound_list: optional["TypeBoundList"] | child

class Attr(AstNode):
   meta: optional["Meta"] | child

class AwaitExpr(Expr):
   attrs: list["Attr"] | child
   expr: optional["Expr"] | child

class BecomeExpr(Expr):
   attrs: list["Attr"] | child
   expr: optional["Expr"] | child

class BinaryExpr(Expr):
   attrs: list["Attr"] | child
   lhs: optional["Expr"] | child
   operator_name: optional[string]
   rhs: optional["Expr"] | child

class BlockExpr(Expr):
   attrs: list["Attr"] | child
   is_async: predicate
   is_const: predicate
   is_gen: predicate
   is_move: predicate
   is_try: predicate
   is_unsafe: predicate
   label: optional["Label"] | child
   stmt_list: optional["StmtList"] | child

class BoxPat(Pat):
   pat: optional["Pat"] | child

class BreakExpr(Expr):
   attrs: list["Attr"] | child
   expr: optional["Expr"] | child
   lifetime: optional["Lifetime"] | child

class CallExpr(Expr):
   arg_list: optional["ArgList"] | child
   attrs: list["Attr"] | child
   function: optional["Expr"] | child

class CastExpr(Expr):
   attrs: list["Attr"] | child
   expr: optional["Expr"] | child
   type_repr: optional["TypeRepr"] | child

class ClosureBinder(AstNode):
   generic_param_list: optional["GenericParamList"] | child

class ClosureExpr(Expr):
   attrs: list["Attr"] | child
   body: optional["Expr"] | child
   closure_binder: optional["ClosureBinder"] | child
   is_async: predicate
   is_const: predicate
   is_gen: predicate
   is_move: predicate
   is_static: predicate
   param_list: optional["ParamList"] | child
   ret_type: optional["RetTypeRepr"] | child

class Const(AssocItem,Item):
   attrs: list["Attr"] | child
   body: optional["Expr"] | child
   is_const: predicate
   is_default: predicate
   name: optional["Name"] | child
   type_repr: optional["TypeRepr"] | child
   visibility: optional["Visibility"] | child

class ConstArg(GenericArg):
   expr: optional["Expr"] | child

class ConstBlockPat(Pat):
   block_expr: optional["BlockExpr"] | child
   is_const: predicate

class ConstParam(GenericParam):
   attrs: list["Attr"] | child
   default_val: optional["ConstArg"] | child
   is_const: predicate
   name: optional["Name"] | child
   type_repr: optional["TypeRepr"] | child

class ContinueExpr(Expr):
   attrs: list["Attr"] | child
   lifetime: optional["Lifetime"] | child

class DynTraitTypeRepr(TypeRepr):
   type_bound_list: optional["TypeBoundList"] | child

class Enum(Item):
   attrs: list["Attr"] | child
   generic_param_list: optional["GenericParamList"] | child
   name: optional["Name"] | child
   variant_list: optional["VariantList"] | child
   visibility: optional["Visibility"] | child
   where_clause: optional["WhereClause"] | child

class ExprStmt(Stmt):
   expr: optional["Expr"] | child

class ExternBlock(Item):
   abi: optional["Abi"] | child
   attrs: list["Attr"] | child
   extern_item_list: optional["ExternItemList"] | child
   is_unsafe: predicate

class ExternCrate(Item):
   attrs: list["Attr"] | child
   name_ref: optional["NameRef"] | child
   rename: optional["Rename"] | child
   visibility: optional["Visibility"] | child

class ExternItemList(AstNode):
   attrs: list["Attr"] | child
   extern_items: list["ExternItem"] | child

class FieldExpr(Expr):
   attrs: list["Attr"] | child
   expr: optional["Expr"] | child
   name_ref: optional["NameRef"] | child

class Function(AssocItem,ExternItem,Item):
   abi: optional["Abi"] | child
   attrs: list["Attr"] | child
   body: optional["BlockExpr"] | child
   generic_param_list: optional["GenericParamList"] | child
   is_async: predicate
   is_const: predicate
   is_default: predicate
   is_gen: predicate
   is_unsafe: predicate
   name: optional["Name"] | child
   param_list: optional["ParamList"] | child
   ret_type: optional["RetTypeRepr"] | child
   visibility: optional["Visibility"] | child
   where_clause: optional["WhereClause"] | child

class FnPtrTypeRepr(TypeRepr):
   abi: optional["Abi"] | child
   is_async: predicate
   is_const: predicate
   is_unsafe: predicate
   param_list: optional["ParamList"] | child
   ret_type: optional["RetTypeRepr"] | child

class ForExpr(Expr):
   attrs: list["Attr"] | child
   iterable: optional["Expr"] | child
   label: optional["Label"] | child
   loop_body: optional["BlockExpr"] | child
   pat: optional["Pat"] | child

class ForTypeRepr(TypeRepr):
   generic_param_list: optional["GenericParamList"] | child
   type_repr: optional["TypeRepr"] | child

class FormatArgsArg(AstNode):
   expr: optional["Expr"] | child
   name: optional["Name"] | child

class FormatArgsExpr(Expr):
   args: list["FormatArgsArg"] | child
   attrs: list["Attr"] | child
   template: optional["Expr"] | child

class GenericArgList(AstNode):
   generic_args: list["GenericArg"] | child

class GenericParamList(AstNode):
   generic_params: list["GenericParam"] | child

class IdentPat(Pat):
   attrs: list["Attr"] | child
   is_mut: predicate
   is_ref: predicate
   name: optional["Name"] | child
   pat: optional["Pat"] | child

class IfExpr(Expr):
   attrs: list["Attr"] | child
   condition: optional["Expr"] | child
   else_: optional["Expr"] | child
   then: optional["BlockExpr"] | child

class Impl(Item):
   assoc_item_list: optional["AssocItemList"] | child
   attrs: list["Attr"] | child
   generic_param_list: optional["GenericParamList"] | child
   is_const: predicate
   is_default: predicate
   is_unsafe: predicate
   self_ty: optional["TypeRepr"] | child
   trait_: optional["TypeRepr"] | child
   visibility: optional["Visibility"] | child
   where_clause: optional["WhereClause"] | child

class ImplTraitTypeRepr(TypeRepr):
   type_bound_list: optional["TypeBoundList"] | child

class IndexExpr(Expr):
   attrs: list["Attr"] | child
   base: optional["Expr"] | child
   index: optional["Expr"] | child

class InferTypeRepr(TypeRepr):
   pass

class ItemList(AstNode):
   attrs: list["Attr"] | child
   items: list["Item"] | child

class Label(AstNode):
   lifetime: optional["Lifetime"] | child

class LetElse(AstNode):
   block_expr: optional["BlockExpr"] | child

class LetExpr(Expr):
   attrs: list["Attr"] | child
   scrutinee: optional["Expr"] | child
   pat: optional["Pat"] | child

class LetStmt(Stmt):
   attrs: list["Attr"] | child
   initializer: optional["Expr"] | child
   let_else: optional["LetElse"] | child
   pat: optional["Pat"] | child
   type_repr: optional["TypeRepr"] | child

class Lifetime(AstNode):
   text: optional[string]

class LifetimeArg(GenericArg):
   lifetime: optional["Lifetime"] | child

class LifetimeParam(GenericParam):
   attrs: list["Attr"] | child
   lifetime: optional["Lifetime"] | child
   type_bound_list: optional["TypeBoundList"] | child

class LiteralExpr(Expr):
   attrs: list["Attr"] | child
   text_value: optional[string]

class LiteralPat(Pat):
   literal: optional["LiteralExpr"] | child

class LoopExpr(Expr):
   attrs: list["Attr"] | child
   label: optional["Label"] | child
   loop_body: optional["BlockExpr"] | child

class MacroCall(AssocItem,ExternItem,Item):
   attrs: list["Attr"] | child
   path: optional["Path"] | child
   token_tree: optional["TokenTree"] | child

class MacroDef(Item):
   args: optional["TokenTree"] | child
   attrs: list["Attr"] | child
   body: optional["TokenTree"] | child
   name: optional["Name"] | child
   visibility: optional["Visibility"] | child

class MacroExpr(Expr):
   macro_call: optional["MacroCall"] | child

class MacroItems(AstNode):
   items: list["Item"] | child

class MacroPat(Pat):
   macro_call: optional["MacroCall"] | child

class MacroRules(Item):
   attrs: list["Attr"] | child
   name: optional["Name"] | child
   token_tree: optional["TokenTree"] | child
   visibility: optional["Visibility"] | child

class MacroStmts(AstNode):
   expr: optional["Expr"] | child
   statements: list["Stmt"] | child

class MacroTypeRepr(TypeRepr):
   macro_call: optional["MacroCall"] | child

class MatchArm(AstNode):
   attrs: list["Attr"] | child
   expr: optional["Expr"] | child
   guard: optional["MatchGuard"] | child
   pat: optional["Pat"] | child

class MatchArmList(AstNode):
   arms: list["MatchArm"] | child
   attrs: list["Attr"] | child

class MatchExpr(Expr):
   attrs: list["Attr"] | child
   scrutinee: optional["Expr"] | child
   match_arm_list: optional["MatchArmList"] | child

class MatchGuard(AstNode):
   condition: optional["Expr"] | child

class Meta(AstNode):
   expr: optional["Expr"] | child
   is_unsafe: predicate
   path: optional["Path"] | child
   token_tree: optional["TokenTree"] | child

class MethodCallExpr(Expr):
   arg_list: optional["ArgList"] | child
   attrs: list["Attr"] | child
   generic_arg_list: optional["GenericArgList"] | child
   name_ref: optional["NameRef"] | child
   receiver: optional["Expr"] | child

class Module(Item):
   attrs: list["Attr"] | child
   item_list: optional["ItemList"] | child
   name: optional["Name"] | child
   visibility: optional["Visibility"] | child

class Name(AstNode):
   text: optional[string]

class NameRef(AstNode):
   text: optional[string]

class NeverTypeRepr(TypeRepr):
   pass

class OffsetOfExpr(Expr):
   attrs: list["Attr"] | child
   fields: list["NameRef"] | child
   type_repr: optional["TypeRepr"] | child

class OrPat(Pat):
   pats: list["Pat"] | child

class Param(AstNode):
   attrs: list["Attr"] | child
   pat: optional["Pat"] | child
   type_repr: optional["TypeRepr"] | child

class ParamList(AstNode):
   params: list["Param"] | child
   self_param: optional["SelfParam"] | child

class ParenExpr(Expr):
   attrs: list["Attr"] | child
   expr: optional["Expr"] | child

class ParenPat(Pat):
   pat: optional["Pat"] | child

class ParenTypeRepr(TypeRepr):
   type_repr: optional["TypeRepr"] | child

class Path(AstNode):
   qualifier: optional["Path"] | child
   part: optional["PathSegment"] | child

class PathExpr(Expr):
   attrs: list["Attr"] | child
   path: optional["Path"] | child

class PathPat(Pat):
   path: optional["Path"] | child

class PathSegment(AstNode):
   generic_arg_list: optional["GenericArgList"] | child
   name_ref: optional["NameRef"] | child
   param_list: optional["ParamList"] | child
   path_type: optional["PathTypeRepr"] | child
   ret_type: optional["RetTypeRepr"] | child
   return_type_syntax: optional["ReturnTypeSyntax"] | child
   type_repr: optional["TypeRepr"] | child

class PathTypeRepr(TypeRepr):
   path: optional["Path"] | child

class PrefixExpr(Expr):
   attrs: list["Attr"] | child
   expr: optional["Expr"] | child
   operator_name: optional[string]

class PtrTypeRepr(TypeRepr):
   is_const: predicate
   is_mut: predicate
   type_repr: optional["TypeRepr"] | child

class RangeExpr(Expr):
   attrs: list["Attr"] | child
   end: optional["Expr"] | child
   operator_name: optional[string]
   start: optional["Expr"] | child

class RangePat(Pat):
   end: optional["Pat"] | child
   operator_name: optional[string]
   start: optional["Pat"] | child

class RecordExpr(Expr):
   path: optional["Path"] | child
   record_expr_field_list: optional["RecordExprFieldList"] | child

class RecordExprField(AstNode):
   attrs: list["Attr"] | child
   expr: optional["Expr"] | child
   name_ref: optional["NameRef"] | child

class RecordExprFieldList(AstNode):
   attrs: list["Attr"] | child
   fields: list["RecordExprField"] | child
   spread: optional["Expr"] | child

class RecordField(AstNode):
   attrs: list["Attr"] | child
   name: optional["Name"] | child
   type_repr: optional["TypeRepr"] | child
   visibility: optional["Visibility"] | child

class RecordFieldList(FieldList):
   fields: list["RecordField"] | child

class RecordPat(Pat):
   path: optional["Path"] | child
   record_pat_field_list: optional["RecordPatFieldList"] | child

class RecordPatField(AstNode):
   attrs: list["Attr"] | child
   name_ref: optional["NameRef"] | child
   pat: optional["Pat"] | child

class RecordPatFieldList(AstNode):
   fields: list["RecordPatField"] | child
   rest_pat: optional["RestPat"] | child

class RefExpr(Expr):
   attrs: list["Attr"] | child
   expr: optional["Expr"] | child
   is_const: predicate
   is_mut: predicate
   is_raw: predicate

class RefPat(Pat):
   is_mut: predicate
   pat: optional["Pat"] | child

class RefTypeRepr(TypeRepr):
   is_mut: predicate
   lifetime: optional["Lifetime"] | child
   type_repr: optional["TypeRepr"] | child

class Rename(AstNode):
   name: optional["Name"] | child

class RestPat(Pat):
   attrs: list["Attr"] | child

class RetTypeRepr(AstNode):
   type_repr: optional["TypeRepr"] | child

class ReturnExpr(Expr):
   attrs: list["Attr"] | child
   expr: optional["Expr"] | child

class ReturnTypeSyntax(AstNode):
   pass

class SelfParam(AstNode):
   attrs: list["Attr"] | child
   is_mut: predicate
   lifetime: optional["Lifetime"] | child
   name: optional["Name"] | child
   type_repr: optional["TypeRepr"] | child

class SlicePat(Pat):
   pats: list["Pat"] | child

class SliceTypeRepr(TypeRepr):
   type_repr: optional["TypeRepr"] | child

class SourceFile(AstNode):
   attrs: list["Attr"] | child
   items: list["Item"] | child

class Static(ExternItem,Item):
   attrs: list["Attr"] | child
   body: optional["Expr"] | child
   is_mut: predicate
   is_static: predicate
   name: optional["Name"] | child
   type_repr: optional["TypeRepr"] | child
   visibility: optional["Visibility"] | child

class StmtList(AstNode):
   attrs: list["Attr"] | child
   statements: list["Stmt"] | child
   tail_expr: optional["Expr"] | child

class Struct(Item):
   attrs: list["Attr"] | child
   field_list: optional["FieldList"] | child
   generic_param_list: optional["GenericParamList"] | child
   name: optional["Name"] | child
   visibility: optional["Visibility"] | child
   where_clause: optional["WhereClause"] | child

class TokenTree(AstNode):
   pass

class Trait(Item):
   assoc_item_list: optional["AssocItemList"] | child
   attrs: list["Attr"] | child
   generic_param_list: optional["GenericParamList"] | child
   is_auto: predicate
   is_unsafe: predicate
   name: optional["Name"] | child
   type_bound_list: optional["TypeBoundList"] | child
   visibility: optional["Visibility"] | child
   where_clause: optional["WhereClause"] | child

class TraitAlias(Item):
   attrs: list["Attr"] | child
   generic_param_list: optional["GenericParamList"] | child
   name: optional["Name"] | child
   type_bound_list: optional["TypeBoundList"] | child
   visibility: optional["Visibility"] | child
   where_clause: optional["WhereClause"] | child

class TryExpr(Expr):
   attrs: list["Attr"] | child
   expr: optional["Expr"] | child

class TupleExpr(Expr):
   attrs: list["Attr"] | child
   fields: list["Expr"] | child

class TupleField(AstNode):
   attrs: list["Attr"] | child
   type_repr: optional["TypeRepr"] | child
   visibility: optional["Visibility"] | child

class TupleFieldList(FieldList):
   fields: list["TupleField"] | child

class TuplePat(Pat):
   fields: list["Pat"] | child

class TupleStructPat(Pat):
   fields: list["Pat"] | child
   path: optional["Path"] | child

class TupleTypeRepr(TypeRepr):
   fields: list["TypeRepr"] | child

class TypeAlias(AssocItem,ExternItem,Item):
   attrs: list["Attr"] | child
   generic_param_list: optional["GenericParamList"] | child
   is_default: predicate
   name: optional["Name"] | child
   type_repr: optional["TypeRepr"] | child
   type_bound_list: optional["TypeBoundList"] | child
   visibility: optional["Visibility"] | child
   where_clause: optional["WhereClause"] | child

class TypeArg(GenericArg):
   type_repr: optional["TypeRepr"] | child

class TypeBound(AstNode):
   generic_param_list: optional["GenericParamList"] | child
   is_async: predicate
   is_const: predicate
   lifetime: optional["Lifetime"] | child
   type_repr: optional["TypeRepr"] | child

class TypeBoundList(AstNode):
   bounds: list["TypeBound"] | child

class TypeParam(GenericParam):
   attrs: list["Attr"] | child
   default_type: optional["TypeRepr"] | child
   name: optional["Name"] | child
   type_bound_list: optional["TypeBoundList"] | child

class UnderscoreExpr(Expr):
   attrs: list["Attr"] | child

class Union(Item):
   attrs: list["Attr"] | child
   generic_param_list: optional["GenericParamList"] | child
   name: optional["Name"] | child
   record_field_list: optional["RecordFieldList"] | child
   visibility: optional["Visibility"] | child
   where_clause: optional["WhereClause"] | child

class Use(Item):
   attrs: list["Attr"] | child
   use_tree: optional["UseTree"] | child
   visibility: optional["Visibility"] | child

class UseTree(AstNode):
   path: optional["Path"] | child
   rename: optional["Rename"] | child
   use_tree_list: optional["UseTreeList"] | child

class UseTreeList(AstNode):
   use_trees: list["UseTree"] | child

class Variant(AstNode):
   attrs: list["Attr"] | child
   expr: optional["Expr"] | child
   field_list: optional["FieldList"] | child
   name: optional["Name"] | child
   visibility: optional["Visibility"] | child

class VariantList(AstNode):
   variants: list["Variant"] | child

class Visibility(AstNode):
   path: optional["Path"] | child

class WhereClause(AstNode):
   predicates: list["WherePred"] | child

class WherePred(AstNode):
   generic_param_list: optional["GenericParamList"] | child
   lifetime: optional["Lifetime"] | child
   type_repr: optional["TypeRepr"] | child
   type_bound_list: optional["TypeBoundList"] | child

class WhileExpr(Expr):
   attrs: list["Attr"] | child
   condition: optional["Expr"] | child
   label: optional["Label"] | child
   loop_body: optional["BlockExpr"] | child

class WildcardPat(Pat):
   pass

class YeetExpr(Expr):
   attrs: list["Attr"] | child
   expr: optional["Expr"] | child

class YieldExpr(Expr):
   attrs: list["Attr"] | child
   expr: optional["Expr"] | child
