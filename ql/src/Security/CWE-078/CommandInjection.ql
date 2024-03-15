/**
 * @name Command built from user-controlled sources
 * @description Building a system command from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision high
 * @id actions/command-injection
 * @tags actions
 *       security
 *       external/cwe/cwe-078
 */

import actions
import codeql.actions.security.CommandInjectionQuery
import CommandInjectionFlow::PathGraph

from CommandInjectionFlow::PathNode source, CommandInjectionFlow::PathNode sink
where CommandInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "Potential command injection in $@, which may be controlled by an external user.", sink,
  sink.getNode().asExpr().(Expression).getRawExpression()
