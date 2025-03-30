package sunabaStudio.codeEditor;

import sunaba.godot.CodeHighlighter;
import sunaba.godot.Color;

class HaxePlugin extends CodeEditorPlugin {
    
    var reservedWords : Array<String> = [
        "abstract",
        "break",
        "case",
        "catch",
        "class",
        "continue",
        "default",
        "do",
        "dynamic",
        "else",
        "enum",
        "extends",
        "extern",
        "false",
        "final",
        "for",
        "from",
        "function",
        "if",
        "implements",
        "import",
        "in",
        "inline",
        "interface",
        "macro",
        "new",
        "null",
        "override",
        "package",
        "private",
        "protected",
        "public",
        "return",
        "static",
        "super",
        "switch",
        "this",
        "throw",
        "to",
        "true",
        "try",
        "typedef",
        "untyped",
        "using",
        "var",
        "while",
    ];

    var functionNames : Array<String> = [
        "trace"
    ];

    override function init() {
        codeHighlighter = new CodeHighlighter();

        codeHighlighter.numberColor = Color.code("#df7aff");
        codeHighlighter.symbolColor = Color.code("#9a9a9a");
        codeHighlighter.functionColor = Color.code("#83cdff");
        codeHighlighter.memberVariableColor = Color.code("#00cebe");
        codeHighlighter.addKeywordColor("extern", Color.code("#9f6eff"));
        codeHighlighter.addKeywordColor("typedef", Color.code("#9f6eff"));
        codeHighlighter.addKeywordColor("class", Color.code("#5195ff"));
        codeHighlighter.addKeywordColor("abstract", Color.code("#5195ff"));
        codeHighlighter.addKeywordColor("extends", Color.code("#5195ff"));
        codeHighlighter.addKeywordColor("interface", Color.code("#5195ff"));
        codeHighlighter.addKeywordColor("enum", Color.code("#5195ff"));
        codeHighlighter.addKeywordColor("function", Color.code("#5195ff"));
        codeHighlighter.addKeywordColor("var", Color.code("#5195ff"));
        codeHighlighter.addKeywordColor("new", Color.code("#5195ff"));
        codeHighlighter.addKeywordColor("macro", Color.code("#5195ff"));
        codeHighlighter.addKeywordColor("import", Color.code("#9f6eff"));
        codeHighlighter.addKeywordColor("package", Color.code("#9f6eff"));
        codeHighlighter.addKeywordColor("using", Color.code("#9f6eff"));
        codeHighlighter.addKeywordColor("from", Color.code("#9f6eff"));
        codeHighlighter.addKeywordColor("to", Color.code("#9f6eff"));
        codeHighlighter.addKeywordColor("in", Color.code("#9f6eff"));
        codeHighlighter.addKeywordColor("return", Color.code("#ff9d00"));
        codeHighlighter.addKeywordColor("break", Color.code("#ff9d00"));
        codeHighlighter.addKeywordColor("continue", Color.code("#ff9d00"));
        codeHighlighter.addKeywordColor("if", Color.code("#ff9d00"));
        codeHighlighter.addKeywordColor("else", Color.code("#ff9d00"));
        codeHighlighter.addKeywordColor("switch", Color.code("#ff9d00"));
        codeHighlighter.addKeywordColor("case", Color.code("#ff9d00"));
        codeHighlighter.addKeywordColor("default", Color.code("#ff9d00"));
        codeHighlighter.addKeywordColor("while", Color.code("#ff9d00"));
        codeHighlighter.addKeywordColor("do", Color.code("#ff9d00"));
        codeHighlighter.addKeywordColor("for", Color.code("#ff9d00"));
        codeHighlighter.addKeywordColor("try", Color.code("#ff9d00"));
        codeHighlighter.addKeywordColor("catch", Color.code("#ff9d00"));
        codeHighlighter.addKeywordColor("throw", Color.code("#ff9d00"));
        codeHighlighter.addKeywordColor("null", Color.code("#ff5fae"));
        codeHighlighter.addKeywordColor("true", Color.code("#ff9d00"));
        codeHighlighter.addKeywordColor("false", Color.code("#ff9d00"));
        codeHighlighter.addKeywordColor("this", Color.code("#ff9d00"));
        codeHighlighter.addKeywordColor("super", Color.code("#ff9d00"));
        codeHighlighter.addKeywordColor("untyped", Color.code("#9f6eff"));
        codeHighlighter.addKeywordColor("dynamic", Color.code("#9f6eff"));
        codeHighlighter.addKeywordColor("override", Color.code("#9f6eff"));
        codeHighlighter.addKeywordColor("implements", Color.code("#ff9d00"));
        codeHighlighter.addKeywordColor("private", Color.code("#9f6eff"));
        codeHighlighter.addKeywordColor("protected", Color.code("#9f6eff"));
        codeHighlighter.addKeywordColor("public", Color.code("#9f6eff"));
        codeHighlighter.addKeywordColor("static", Color.code("#9f6eff"));
        codeHighlighter.addKeywordColor("trace", Color.code("#ff8080"));
        codeHighlighter.addColorRegion("/*", "*/", Color.code("#9bda7b"));
        codeHighlighter.addColorRegion("//", "\n", Color.code("#9bda7b"), true);
        codeHighlighter.addColorRegion("\"", "\"", Color.code("#9bda7b"));
        codeHighlighter.addColorRegion("'", "'", Color.code("#9bda7b"));

        widget.codeEdit.syntaxHighlighter = codeHighlighter;
    }
}