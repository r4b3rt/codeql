// generated by codegen, do not edit
import codeql.rust.elements
import TestUtils

from TypeArg x, string hasTypeRepr
where
  toBeTested(x) and
  not x.isUnknown() and
  if x.hasTypeRepr() then hasTypeRepr = "yes" else hasTypeRepr = "no"
select x, "hasTypeRepr:", hasTypeRepr
