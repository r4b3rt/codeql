// generated by codegen, do not edit
import codeql.rust.elements
import TestUtils

from ArgList x, int index
where toBeTested(x) and not x.isUnknown()
select x, index, x.getArg(index)
