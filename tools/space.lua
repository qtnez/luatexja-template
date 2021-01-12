%%% 消除中文問號及驚嘆號後面多餘的空白。
\def\exsp#1{\unskip#1\hspace{0pt}}
\begin{luacode}
function dosub(s)
  s = string.gsub(s, '！', '\\exsp！')
  s = string.gsub(s, '？', '\\exsp？')
  return(s)
end
\end{luacode}
\AtBeginDocument{%
  \luaexec{luatexbase.add_to_callback("process_input_buffer", dosub, "dosub")}%
}
