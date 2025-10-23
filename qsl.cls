
\RequirePackage{expl3}
\ProvidesExplClass{qsl}{2024/10/14}{0.3.0}{ QSL Card template}
\LoadClass[10pt,fontset=windows]{ctexart}

\RequirePackage{l3keys2e}
\RequirePackage{trace}

\RequirePackage{xparse}
\RequirePackage{array}
\RequirePackage{tikz}
\RequirePackage{graphics}
\RequirePackage{multirow}
\RequirePackage{amssymb}
\RequirePackage{geometry}

\usetikzlibrary{shapes.arrows}

\setlength{\parindent}{0pt}
\geometry{paperheight=89mm, paperwidth=127mm, left=10mm, right=10mm, top=10mm, bottom=10mm}


% 正面图案
\cs_new:Npn \g_cover_image:nn #1#2 {
    \tl_if_empty:nTF {#2} {
        \relax
    }{
        \begin{tikzpicture}[overlay,remember~picture]
            \node(1) at (current~page.center) { \resizebox{133.5mm}{89mm}{\includegraphics[#1]{#2}}};
        \end{tikzpicture}
    }
}

% 封面(整面图案)
\DeclareDocumentEnvironment{front}{ O{} m +b }{
    \g_cover_image:nn {#1}{#2}
    {#3}
}{}

% 背面 QSL 信息
\tl_new:N \g_qsl_title_tl % 抬头
\tl_new:N \g_qsl_callsign_tl  % 呼号
\tl_new:N \g_qsl_cq_zone_tl %   CQ 分区
\tl_new:N \g_qsl_itu_zone_tl %  ITU 分区
\tl_new:N \g_qsl_grid_zone_tl % 梅登海德网格 分区
\keys_define:nn {qsl} {
    callsign .tl_set:N = \g_qsl_callsign_tl,
    cq .tl_set:N = \g_qsl_cq_zone_tl,
    itu .tl_set:N = \g_qsl_itu_zone_tl,
    grid .tl_set:N = \g_qsl_grid_zone_tl,
}
\DeclareDocumentCommand{\setup} {m} {
    \keys_set:nn {qsl} {#1}
}
\DeclareDocumentCommand{\title}{m O{}}{
    \tl_set:Nn \g_qsl_title_tl {
        \begin{minipage}{105mm} \centering
            \begin{tabular}{c}
                {\huge \bfseries \rmfamily  #1 } \\
                { \large \scshape #2 } \\
            \end{tabular}
        \end{minipage}
    }
}
\DeclareDocumentCommand{\customtitle} {m} {
    \tl_set:Nn \g_qsl_title_tl {
        \begin{minipage}{105mm} \centering
            #1
        \end{minipage}
    }
}

% 确认来源
\cs_new:Npn \g_qsl_checkbox:n #1 {
    \bool_if:nTF {
        $\checkmark$
    } {
        $\Box$
    }
}
\cs_new:Npn \g_qsl_confirming_qsl:nnn #1 #2 #3  {
    \bool_if:nTF {#1} {
        \begin{tabular}{ccc}
            {\footnotesize CONFIRMING} & { \footnotesize \g_qsl_checkbox:n{#2} OUR~QSL/我们的通联} & {\footnotesize \g_qsl_checkbox:n{#3} YOUR~RECV~RPT/您的收听}  \\
        \end{tabular}
    } {
        \begin{tabular}{cc}
            {\footnotesize CONFIRMING} &  {\footnotesize \g_qsl_checkbox:n{#3} YOUR~RECV~RPT/您的收听}  \\
        \end{tabular}
    }
}

% 通联信息
\tl_new:N \l_qsl_info_date
\tl_new:N \l_qsl_info_time
\tl_new:N \l_qsl_info_freq
\tl_new:N \l_qsl_info_mode
\tl_new:N \l_qsl_info_rst
\tl_new:N \l_qsl_info_trx
\tl_new:N \l_qsl_info_watts
\tl_new:N \l_qsl_info_ant
\tl_new:N \l_qsl_target_callsign
\cs_new:Nn \g_qsl_information: {
    \begin{tabular}{| m{22mm}<{\centering}| m{22mm}<{\centering}| m{22mm}<{\centering}| m{22mm}<{\centering}|}
        \hline
        {\footnotesize DATE/日期} & {\footnotesize TIME/时间} & { \small  MHZ/频率 } & {\footnotesize MOD/模式}  \\ \hline
        \multirow{2}{22mm}{\l_qsl_info_date} & \multirow{2}{22mm}{\l_qsl_info_time} & \multirow{2}{22mm}{\l_qsl_info_freq} & \multirow{2}{22mm}{\l_qsl_info_mode} & \\
        & & & & \\\hline
        {\footnotesize TRX/设备} & {\footnotesize WATTS/功率} & {\footnotesize ANT/天线}& {\footnotesize  RST/信号报告}  \\ \hline
        \multirow{2}{22mm}{\l_qsl_info_trx} & \multirow{2}{22mm}{\l_qsl_info_watts} & \multirow{2}{22mm}{\l_qsl_info_ant} & \multirow{2}{22mm}{\l_qsl_info_rst} & \\
        & & & & \\\hline
    \end{tabular}
}
% 卡片信息
\cs_new:Npn \g_qsl_qsl: #1 #2 {
    \begin{tabular}{l l l l l}
        \textbf{VY} & {73!} & & GRID & \textbf{\g_qsl_grid_zone_tl}  \\
        CQ & \textbf{\g_qsl_cq_zone_tl} & & ITU & \textbf{\g_qsl_itu_zone_tl}
    \end{tabular}
}
\cs_new:Nn \g_qsl_callsign_display: {
    {\Huge \bfseries  \g_qsl_callsign_tl}
}
% \cs_new:Nn
\DeclareDocumentCommand{\back}{} {
    \begin{tikzpicture}[overlay,remember~picture]
        \node [anchor=north] (title) at (1, 0) {
            \includegraphics[height=22mm]{CRAC.eps}
        };
        \node[anchor=north] (title) at (6.5, 0) {
            \resizebox{9cm}{!}{\g_qsl_title_tl}
        };
        \node[anchor=west] (callsign) at (2.1, -1.8) {
            \resizebox{4cm}{!}{\g_qsl_callsign_display:}
        };
        \draw[rounded~corners] (7,-1.3) rectangle (11, -2.2);
        \node[single~arrow ] at (6,-3) {} ;
    \end{tikzpicture}
}

\tl_new:N \l_qsl_type
\keys_define:nn {card} {
    worked .tl_set:N = \l_qsl_target_callsign,
    date .tl_set:N =  \l_qsl_info_date,
    time .tl_set:N =  \l_qsl_info_time,
    freq .tl_set:N =  \l_qsl_info_freq,
    mode .tl_set:N =  \l_qsl_info_mode,
    rst .tl_set:N =  \l_qsl_info_rst,
    trx .tl_set:N =  \l_qsl_info_trx,
    watts .tl_set:N =  \l_qsl_info_watts,
    ant .tl_set:N =  \l_qsl_info_ant,
    type .tl_set:N = \l_qsl_type,
    type .default:n = {qsl},
}

\DeclareDocumentEnvironment{card}{ s O{} m O{} +b }{
    \tl_clear:N \l_qsl_type
    \tl_clear:N \l_qsl_target_callsign
    \tl_clear:N \l_qsl_info_date
    \tl_clear:N \l_qsl_info_time
    \tl_clear:N \l_qsl_info_freq
    \tl_clear:N \l_qsl_info_mode
    \tl_clear:N \l_qsl_info_rst
    \tl_clear:N \l_qsl_info_trx
    \tl_clear:N \l_qsl_info_watts
    \tl_clear:N \l_qsl_info_ant
    \tl_clear:N \l_qsl_type

    \keys_set:nn { card } {#4}
    \clearpage \thispagestyle{empty}
    \newgeometry{left=4mm, right=4mm, top=4mm, bottom=4mm}
    \bool_if:nF {#1} {
        \begin{front}[#2]{#3}
            #5
        \end{front}
    }
    \clearpage \thispagestyle{empty}
    \newgeometry{left=4mm, right=4mm, top=4mm, bottom=4mm}
    \back
    \restoregeometry
}{}



\DeclareDocumentCommand{\de}{}{DE~\g_qsl_callsign_tl}