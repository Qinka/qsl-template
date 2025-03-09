
\RequirePackage{expl3,l3keys2e,xparse,trace}
\ProvidesExplClass{qsl}{2024/10/14}{0.2.0}{ QSL Card template}
\LoadClass[10pt]{ctexart}

\RequirePackage{xparse}
\RequirePackage{array}
\RequirePackage{tikz}
\RequirePackage{graphics}
\RequirePackage{multirow}
\RequirePackage{amssymb}
\RequirePackage{geometry}

\setlength{\parindent}{0pt}
\geometry{paperheight=89mm, paperwidth=133.5mm, left=10mm, right=10mm, top=10mm, bottom=10mm}


\str_new:N\g_@addr
\str_new:N\g_@pc
\str_new:N\g_@title
\str_new:N\g_@callsign@cn
\str_new:N\g_@callsign@en
\str_set:Nn\g_@title@cn{中华人民共和国个人业余电台}
\str_set:Nn\g_@title@en{Personal~Amateur~Radio~Station~of~P.R.China}

\DeclareDocumentCommand\callsign{m}{\str_set:Nn \g_@callsign {#1}}
\DeclareDocumentCommand\cq{m}{\str_set:Nn \g_@cq {#1}}
\DeclareDocumentCommand\itu{m}{\str_set:Nn \g_@itu {#1}}
\DeclareDocumentCommand\addr{m}{\str_set:Nn \g_@addr {#1}}
\DeclareDocumentCommand\pc{m}{\str_set:Nn \g_@pc {#1}}
\DeclareDocumentCommand\title{m m}{\str_set:Nn \g_@title@cn {#1} \str_set:Nn \g_@title@en {#2}}

\DeclareDocumentCommand\de{}{DE~\g_@callsign}


\DeclareDocumentEnvironment{front}{ O{} m +b}{ %
    \begin{tikzpicture}[overlay,remember~picture]
        \node(1) at (current~page.center) { \resizebox{133.5mm}{89mm}{\includegraphics[#1]{#2}}}  ;
    \end{tikzpicture}
    {#3}
}{}

\cs_new:Nn \card_part_@head: {
    \begin{tikzpicture}[remember~picture]
        \node(1)[xshift=-15mm,yshift=28mm] at (current~page.center) {
            \includegraphics[height=22mm]{CRAC.eps}
        };
        \node(2)[xshift=45mm,yshift=33mm] at (current~page.center) {
            \begin{minipage}{105mm} \centering
                \begin{tabular}{c}
                    {\huge \bfseries \rmfamily  \g_@title@cn } \\
                    { \large \scshape \g_@title@en } \\
                \end{tabular}
            \end{minipage}
        };
    \end{tikzpicture}
}

\cs_new:Nn \card_part_@callsign: {
    \begin{tabular}{m{16mm}m{59mm}<{\centering}|m{39mm}<{\centering}|}
        \cline{3-3}
        & \multirow{2}{*}{\Huge \bfseries \g_@callsign}& \multirow{2}{*}{\footnotesize \scshape \itshape To~Radio \vspace{.7cm}} \\
        & & \\ \cline{3-3}
    \end{tabular}
}

\cs_new:Nn \card_part_@qsl_check: {
    \begin{tabular}{ccccc}
        {\footnotesize CONFIRMING} & { \footnotesize $\Box$ OUR~QSL} & {\footnotesize  $\Box$ YOUR~RECV~REPORT} &  {\footnotesize \textbf{CQ~zone:\,\g_@cq}}  &  {\footnotesize \textbf{ITU~zone:\,\g_@itu}} \\
    \end{tabular}
}

\cs_new:Nn \card_part_@swl_check: {
    \begin{tabular}{cccc}
        {\footnotesize CONFIRMING}  & {\footnotesize  $\Box$ YOUR~RECV~REPORT} &  {\footnotesize \textbf{CQ~zone:\,\g_@cq}}  &  {\footnotesize \textbf{ITU~zone:\,\g_@itu}} \\
    \end{tabular}
}

\cs_new:Nn \card_part_@qsl_info: {
    \begin{tabular}{| m{22mm}<{\centering}| m{22mm}<{\centering}| m{22mm}<{\centering}| m{22mm}<{\centering}| m{22mm}<{\centering}|}
        \hline
        {\footnotesize DATE/日期} & {\footnotesize TIME/时间} & { \small  MHZ/频率 } & {\footnotesize MOD/模式} & {\footnotesize  RST/信号报告} \\ \hline
        & & & & \\
        & & & & \\\hline
        {\footnotesize TRX/设备} & {\footnotesize WATTS/功率} & {\footnotesize ANT/天线} &  \multicolumn{2}{l|}{$\Box$ PSE/请回卡片 } \\ \hline
        &  &  & \multicolumn{2}{l|}{ $\Box$ TRX~QSL/感谢您的卡片 } \\ \cline{4-5}
        &  &  & \multicolumn{2}{l|}{ $\Box$  VY~73!/通联愉快！ } \\ \hline
        \multicolumn{5}{l}{\bfseries QTH:} \\
        \multicolumn{5}{l}{\bfseries ADD:~\g_@addr} \\
        \multicolumn{3}{l}{\bfseries \quad PC:~\g_@pc} & \multicolumn{2}{l}{ \bfseries OP:} \\
    \end{tabular}
}

\cs_new:Nn \card_part_@swl_info: {
    \begin{tabular}{| m{22mm}<{\centering}| m{22mm}<{\centering}| m{22mm}<{\centering}| m{22mm}<{\centering}| m{22mm}<{\centering}|}
        \hline
        {\footnotesize DATE/日期} & {\footnotesize TIME/时间} & { \small  MHZ/频率 } & {\footnotesize MOD/模式} & {\footnotesize  RST/信号报告} \\ \hline
        & & & & \\
        & & & & \\\hline
        {\footnotesize TRX/设备} & {\footnotesize WATTS/功率} & {\footnotesize ANT/天线} & \multicolumn{2}{l|}{\multirow{2}{*}{
            $\Box$ \parbox{44mm}{TRX~UR~ FOR~LISTENING \vspace{-1.5mm}\\  感谢您的收听} %
        }} \\ \cline{1-3}
        &  &  & \multicolumn{2}{l|}{  }  \\ \cline{4-5}
        &  &  &  \multicolumn{2}{l|}{ $\Box$  VY~73!/通联愉快！ } \\ \hline
        \multicolumn{5}{l}{\bfseries QTH:} \\
        \multicolumn{5}{l}{\bfseries ADD:~\g_@addr} \\
        \multicolumn{3}{l}{\bfseries \quad PC:~\g_@pc} & \multicolumn{1}{l}{ \bfseries OP:} \\
    \end{tabular}
}

\cs_new:Nn \card_back_@qsl: {
    \begin{center}
        \setlength\tabcolsep{3pt}
        \card_part_@head:
        \vskip-10mm
        \card_part_@callsign: \\
        \card_part_@qsl_check: \\
        \card_part_@qsl_info:
    \end{center}
}


\cs_new:Nn \card_back_@swl: {
    \begin{center}
        \setlength\tabcolsep{3pt}
        \card_part_@head:
        \vskip-10mm
        \card_part_@callsign: \\
        \card_part_@swl_check: \\
        \card_part_@swl_info:
    \end{center}
}


\DeclareDocumentEnvironment{back}{ O{qsl} +b }{
    {#2} \cs:w card_back_@ #1 : \cs_end:
}{}

\DeclareDocumentEnvironment{card}{ O{} m +b }{ %
    \newgeometry{left=10mm, right=10mm, top=10mm, bottom=10mm}
    \clearpage \thispagestyle{empty}
    \begin{front}[#1]{#2}
        #3
    \end{front}
    \restoregeometry
    \clearpage \thispagestyle{empty}
    \newgeometry{left=4mm, right=4mm, top=4mm, bottom=4mm}
    \begin{back}[qsl]
    \end{back}
    \restoregeometry
}{}


\DeclareDocumentEnvironment{swl}{ O{} m +b }{ %
    \newgeometry{left=10mm, right=10mm, top=10mm, bottom=10mm}
    \clearpage \thispagestyle{empty}
    \begin{front}[#1]{#2}
        #3
    \end{front}
    \restoregeometry
    \clearpage \thispagestyle{empty}
    \newgeometry{left=4mm, right=4mm, top=4mm, bottom=4mm}
    \begin{back}[swl]
    \end{back}
    \restoregeometry
}{}

\endinput
