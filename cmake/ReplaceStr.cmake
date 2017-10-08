FILE(READ ${infile} f0)
STRING( REGEX_REPLACE "${from}" "${to}" f1 "${f0}")
FILE(WRITE ${outfile} "${f1}")