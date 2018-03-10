defmodule GraphQL.ParserTest do
  use ExUnit.Case, async: true
  # doctest GraphQL.Parser

  import ExUnit.TestHelper

  test "simple query" do
    assert_parse_success "{ field }",
    %{definitions: [%{directives: nil, kind: "OperationDefinition",
      loc: %{end: %{column: 10, line: 1}, start: %{column: 1, line: 1}}, name: nil, operation: "query",
      selectionSet: %{kind: "SelectionSet", loc: %{end: %{column: 10, line: 1}, start: %{column: 1, line: 1}},
        selections: [%{alias: nil, arguments: nil, directives: nil,
           kind: "Field", loc: %{end: %{column: 8, line: 1}, start: %{column: 3, line: 1}},
           name: %{kind: "Name", loc: %{end: %{column: 8, line: 1}, start: %{column: 3, line: 1}}, value: "field"},
           selectionSet: nil}]}, variableDefinitions: nil}], kind: "Document",
    loc: %{end: %{column: 10, line: 1}, start: %{column: 1, line: 1}}}
  end

  test "complex query with variable inline values" do
    assert_parse_success "{ field(complex: { a: { b: [ $var ] } }) }",
    %{definitions: [%{directives: nil, kind: "OperationDefinition",
      loc: %{end: %{column: 43, line: 1}, start: %{column: 1, line: 1}}, name: nil, operation: "query",
      selectionSet: %{kind: "SelectionSet", loc: %{end: %{column: 43, line: 1}, start: %{column: 1, line: 1}},
        selections: [%{alias: nil,
           arguments: [%{kind: "Argument", loc: %{end: %{column: 40, line: 1}, start: %{column: 9, line: 1}},
              name: %{kind: "Name", loc: %{end: %{column: 16, line: 1}, start: %{column: 9, line: 1}},
                value: "complex"},
              value: %{fields: [%{kind: "ObjectField",
                   loc: %{end: %{column: 38, line: 1}, start: %{column: 20, line: 1}},
                   name: %{kind: "Name", loc: %{end: %{column: 21, line: 1}, start: %{column: 20, line: 1}},
                     value: "a"},
                   value: %{fields: [%{kind: "ObjectField",
                        loc: %{end: %{column: 36, line: 1}, start: %{column: 25, line: 1}},
                        name: %{kind: "Name", loc: %{end: %{column: 26, line: 1}, start: %{column: 25, line: 1}},
                          value: "b"},
                        value: %{kind: "ListValue", loc: %{end: %{column: 36, line: 1}, start: %{column: 28, line: 1}},
                          values: [%{kind: "Variable",
                             loc: %{end: %{column: 34, line: 1}, start: %{column: 30, line: 1}},
                             name: %{kind: "Name", loc: %{end: %{column: 34, line: 1}, start: %{column: 30, line: 1}},
                               value: "var"}}]}}], kind: "ObjectValue",
                     loc: %{end: %{column: 38, line: 1}, start: %{column: 23, line: 1}}}}], kind: "ObjectValue",
                loc: %{end: %{column: 40, line: 1}, start: %{column: 18, line: 1}}}}], directives: nil, kind: "Field",
           loc: %{end: %{column: 41, line: 1}, start: %{column: 3, line: 1}},
           name: %{kind: "Name", loc: %{end: %{column: 8, line: 1}, start: %{column: 3, line: 1}}, value: "field"},
           selectionSet: nil}]}, variableDefinitions: nil}], kind: "Document",
    loc: %{end: %{column: 43, line: 1}, start: %{column: 1, line: 1}}}
  end

  test "failure when fragments named on" do
    assert_parse_failure "fragment on on on { on }",
    "1.10-11: syntax error, unexpected on"
  end
end
