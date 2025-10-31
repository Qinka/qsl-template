
\RequirePackage{expl3}
\ProvidesExplClass{qsl}{2024/10/14}{0.3.0}{ QSL Card template}
\LoadClass[10pt]{ctexart}

\RequirePackage{l3keys2e}
\RequirePackage{trace}

\RequirePackage{xparse}
\RequirePackage{array}
\RequirePackage{tikz}
\RequirePackage{graphics}
\RequirePackage{multirow}
\RequirePackage{amssymb}
\RequirePackage{geometry}
\RequirePackage{setspace}

\usetikzlibrary{shapes.arrows}

\setlength{\parindent}{0pt}
\geometry{paperheight=89mm, paperwidth=127mm, left=10mm, right=10mm, top=10mm, bottom=10mm}


% min-size box
\newsavebox{\mybox}
% \MinWidthBox[<min width>]{<content>}
\cs_new:Npn \g_qsl_min_width_box:nn #1#2 {
    \sbox{\mybox}{#2}%
    \ifdim\wd\mybox < #1
        {\makebox[#1][c]{\usebox{\mybox}}}
    \else
        {\usebox{\mybox}}
    \fi
}


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
    \g_cover_image:nn {#1}{#2} #3
}{}

% 背面 QSL 信息
\tl_new:N \g_qsl_title_tl % 抬头
\tl_new:N \g_qsl_callsign_tl  % 呼号
\tl_new:N \g_qsl_address_tl % 地址
\tl_new:N \g_qsl_cq_zone_tl %   CQ 分区
\tl_new:N \g_qsl_itu_zone_tl %  ITU 分区
\tl_new:N \g_qsl_grid_zone_tl % 梅登海德网格 分区
\tl_new:N \g_qsl_type_tl % QSO or SWL
\keys_define:nn {qsl} {
    callsign .tl_set:N = \g_qsl_callsign_tl,
    cq .tl_set:N = \g_qsl_cq_zone_tl,
    itu .tl_set:N = \g_qsl_itu_zone_tl,
    grid .tl_set:N = \g_qsl_grid_zone_tl,
    address .tl_set:N = \g_qsl_address_tl,
    type .tl_set:N = \g_qsl_type_tl,
    % type .default:n = {qso}
}
\DeclareDocumentCommand{\setup} {m} {
    \keys_set:nn {qsl} {#1}
}
\DeclareDocumentCommand{\title}{m O{}}{
    \tl_set:Nn \g_qsl_title_tl {
        \vbox{\centering
            \resizebox{93mm}{!}{\g_qsl_min_width_box:nn {93mm} {
                \hbox{\hfill\centering \huge \bfseries \rmfamily  #1}
            }}\\
            \resizebox{93mm}{!}{\g_qsl_min_width_box:nn {93mm} {
                \hbox{\centering \large \scshape #2}
            }}
        }
    }
}
\DeclareDocumentCommand{\customtitle} {m} {
    \tl_set:Nn \g_qsl_title_tl { #1 }
}

% 确认来源
\cs_new:Npn \g_qsl_checkbox:n #1 {
    \bool_if:nTF #1 {
        $\checkmark$
    } {
        $\Box$
    }
}
\cs_new:Nn \g_qsl_confirming_type: {
        \tl_if_empty:NTF \l_qsl_type_tl {
            \g_qsl_type_tl
        } {
            \l_qsl_type_tl
        }
}
\cs_new:Npn \g_qsl_confirming_qsl: {
    \str_case_e:nnF {\g_qsl_confirming_type:} {
        {qso} {
            \begin{tabular}{cc}
                {\footnotesize CONFIRMING/确认} &
                { \footnotesize \g_qsl_checkbox:n{\c_true_bool} OUR~QSL/我们的通联} \\
            \end{tabular}
        }
        {swl} {
            \begin{tabular}{cc}
                {\footnotesize CONFIRMING/确认} &
                {\footnotesize \g_qsl_checkbox:n{\c_true_bool} YOUR~RECV~RPT/您的收听}  \\
            \end{tabular}
        }
        {eyeball} {
            \begin{tabular}{cc}
                {\footnotesize CONFIRMING/确认} &
                {\footnotesize \g_qsl_checkbox:n{\c_true_bool} EYEBALL~CARD}  \\
            \end{tabular}
        }
    }{
        \begin{tabular}{ccc}
            {\footnotesize CONFIRMING/确认} &
            { \footnotesize \g_qsl_checkbox:n{\c_false_bool} OUR~QSL/我们的通联} &
            {\footnotesize \g_qsl_checkbox:n{\c_false_bool} YOUR~RECV~RPT/您的收听} \\
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
\bool_new:N \l_qsl_conf_qso_bool
\bool_new:N \l_qsl_conf_swl_bool
\cs_new:Npn \g_qsl_multirow:nnn #1#2#3 {
    \multirow{#1}{#2}{
        \resizebox{#2}{!}{
            \g_qsl_min_width_box:nn {#2} {
                \parbox{#2}{#3}
            }
        }
    }
}
\cs_new:Nn \g_qsl_information: {
    \begin{tabular}{| m{22mm}<{\centering}| m{22mm}<{\centering}| m{22mm}<{\centering}| m{22mm}<{\centering}|}
        \hline
        {\footnotesize DATE/日期} & {\footnotesize TIME/时间} & { \small  MHZ/频率 } & {\footnotesize MOD/模式}  \\ \hline
        \g_qsl_multirow:nnn {2}{22mm}{\l_qsl_info_date} & \g_qsl_multirow:nnn{2}{22mm}{\l_qsl_info_time}  &\g_qsl_multirow:nnn{2}{22mm}{\l_qsl_info_freq} & \g_qsl_multirow:nnn{2}{22mm}{\l_qsl_info_mode} \\
        & & & \\ \hline
        {\footnotesize TRX/设备} & {\footnotesize WATTS/功率} & {\footnotesize ANT/天线}& {\footnotesize  RST/信号报告}  \\ \hline
        \multirow{2}{22mm}{\l_qsl_info_trx} & \multirow{2}{22mm}{\l_qsl_info_watts} & \multirow{2}{22mm}{\l_qsl_info_ant} & \multirow{2}{22mm}{\l_qsl_info_rst} \\
        & & & \\\hline
    \end{tabular}
}
% 卡片信息
\cs_new:Npn \g_qsl_qsl: #1 #2 {
    \renewcommand{\arraystretch}{0.1}
    \begin{tabular}{ rlrl}
        {\scriptsize \bfseries VY:} & {\scriptsize \bfseries 73!}  &
        {\scriptsize \bfseries CQ:} & {\scriptsize \bfseries \g_qsl_cq_zone_tl}   \\
        {\scriptsize \bfseries GRID:} & {\scriptsize \bfseries \g_qsl_grid_zone_tl} & {\scriptsize \bfseries ITU:} & {\scriptsize \bfseries \g_qsl_itu_zone_tl} \\
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
        \node[anchor=north] (title) at (6.6, 0) {
            \g_qsl_title_tl
        };
        \node[anchor=center] (callsign) at (4.2, -1.9) {
            \resizebox{4cm}{!}{\g_qsl_min_width_box:nn {4cm} {\g_qsl_callsign_display:}}
        };
        \draw[rounded~corners] (7,-1.4) rectangle (11, -2.3)  node[anchor=center,pos=0.5]{\resizebox{3cm}{!}{\g_qsl_min_width_box:nn {3cm} {
            \Large\bfseries \l_qsl_target_callsign
        }}};
        \node[] at (6.6,-1.9) {TO} ;
        \node[] at (6, -2.5) {\g_qsl_confirming_qsl: };
        \node[anchor=north] at (6, -2.6) {\g_qsl_information:};
        \node[anchor=south] at (3, -6.8) {\g_qsl_qsl: {} {}};
        \node[anchor=west] at (0.6, -7.) { \resizebox{5cm}{!}{
            \g_qsl_min_width_box:nn {5cm} {\parbox{5cm}{
                \scriptsize \bfseries \setstretch{0.8} \g_qsl_address_tl
            }
        }}};
        \node[anchor=west] at (7, -7) {
            OP:
        };
    \end{tikzpicture}
}

\tl_new:N \l_qsl_type_tl
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
    type .tl_set:N = \l_qsl_type_tl,
}
\DeclareDocumentEnvironment{card}{ s O{} m O{} +b }{}{
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
    \newgeometry{left=10mm, right=10mm, top=10mm, bottom=10mm}
    \bool_if:nF {#1} {
        \begin{front}[#2]{#3}
            #5
        \end{front}
    }
    \clearpage \thispagestyle{empty}
    \newgeometry{left=4mm, right=4mm, top=4mm, bottom=4mm}
    \back
    \restoregeometry
}



\DeclareDocumentCommand{\de}{}{DE~\g_qsl_callsign_tl}