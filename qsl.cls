\ProvidesClass{qsl}[2024/10/14 QSL Card]
\LoadClass[10pt]{ctexart}

\newif\if@paper\@paperfalse

\RequirePackage{xparse}
\RequirePackage{array}
\RequirePackage{tikz}
\RequirePackage{graphics}
\RequirePackage{multirow}
\RequirePackage{amssymb}
\RequirePackage{geometry}

\def\@addr{}
\def\@pc{}

\newcommand{\callsign}[1]{\def\@callsign{#1}}
\newcommand{\cq}[1]{\def\@cq{#1}}
\newcommand{\itu}[1]{\def\@itu{#1}}
\newcommand{\de}{DE \@callsign}
\newcommand{\addr}[1]{\def\@addr{#1}}
\newcommand{\pc}[1]{\def\@pc{#1}}

\setlength{\parindent}{0pt}
\geometry{paperheight=89mm, paperwidth=133.5mm, left=10mm, right=10mm, top=10mm, bottom=10mm}

\NewDocumentEnvironment{cardpage}{+b}{
    % \newgeometry{left=10mm, right=10mm, top=10mm, bottom=10mm}
    #1
    % \restoregeometry
}

\NewDocumentEnvironment{back}{+b}{
    #1
    \begin{center}
    \begin{tikzpicture}[remember picture]
        \node(1)[xshift=-15mm,yshift=28mm] at (current page.center) {
            \includegraphics[height=22mm]{CRAC.eps}
        };
        \node(2)[xshift=45mm,yshift=33mm] at (current page.center) {
            \begin{minipage}{105mm} \centering
                \begin{tabular}{c}
                    {\huge \bfseries \rmfamily  中华人民共和国个人业余电台} \\
                    { \large \scshape Personal Amateur Radio Station of P.R.China } \\
                \end{tabular}
            \end{minipage}
        };
    \end{tikzpicture}
        \vskip-10mm
        \setlength\tabcolsep{3pt}
        \begin{tabular}{m{20mm}m{45mm}<{\centering}|m{45mm}<{\centering}|}
            \cline{3-3}
            \parbox{100mm}{}& \multirow{2}{*}{\Huge \bfseries \@callsign}& \multirow{2}{*}{\footnotesize \scshape \itshape To Radio \vspace{.7cm}} \\
            & & \\ \cline{3-3}
        \end{tabular}
        \begin{tabular}{ccccc}
            {\footnotesize CONFIRMING} & { \footnotesize $\Box$ OUR QSL} & {\footnotesize  $\Box$ YOUR SWL REPORT} &  {\footnotesize \textbf{CQ zone: \@cq}}  &  {\footnotesize \textbf{ITU zone: \@itu}} \\
        \end{tabular}
        \begin{tabular}{| m{22mm}<{\centering}| m{22mm}<{\centering}| m{22mm}<{\centering}| m{22mm}<{\centering}| m{22mm}<{\centering}|}
            \hline
            {\footnotesize DATE/日期} & {\footnotesize TIME/时间} & { \small  MHZ/频率 } & {\footnotesize MOD/模式} & {\footnotesize  RST/信号报告} \\ \hline
            & & & & \\
            & & & & \\\hline
            {\footnotesize TRX/设备} & {\footnotesize WATTS/功率} & {\footnotesize ANT/天线} &  \multicolumn{2}{l|}{$\Box$ PSE/请回卡片 } \\ \hline
            &  &  & \multicolumn{2}{l|}{ $\Box$ TRX QSL/感谢您的卡片 } \\ \cline{4-5}
            &  &  & \multicolumn{2}{l|}{ $\Box$  VY 73!/通联愉快！ } \\ \hline
            \multicolumn{5}{l}{\bfseries QTH:} \\
            \multicolumn{5}{l}{\bfseries ADD: \@addr} \\
            \multicolumn{3}{l}{\bfseries \quad PC: \@pc} & \multicolumn{2}{l}{ \bfseries OP:} \\
        \end{tabular}
    \end{center}
}

\NewDocumentEnvironment{front}{ O{} m +b}{ %
    \begin{tikzpicture}[overlay,remember picture]
        \node(1) at (current page.center) { \resizebox{150mm}{100mm}{\includegraphics[#1]{#2}}}  ;
    \end{tikzpicture}
    {#3}
}


\NewDocumentEnvironment{card}{ O{} m +b}{ %
        \newgeometry{left=10mm, right=10mm, top=10mm, bottom=10mm}
        \clearpage \thispagestyle{empty}
        \begin{front}[#1]{#2}
            #3
        \end{front}
        \restoregeometry
        \clearpage \thispagestyle{empty}
        \newgeometry{left=4mm, right=4mm, top=4mm, bottom=4mm}
        \begin{back}
        \end{back}
        \restoregeometry
}

\DeclareOption{a4}{\@papertrue}
\ProcessOptions \endinput
