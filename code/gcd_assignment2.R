install.packages("sqldf")

nchar('<meta name="Distribution" content="Global" />')
nchar('<script type="text/javascript">')
nchar('  })();')
nchar('				<ul class="sidemenu">')

data_tmp <- read.fwf("./data/getdata-wksst8110.for",
                     skip=4,
                     widths=c(12, 7, 4, 9, 4, 9, 4, 9, 4))
head(data_tmp)

sum(data_tmp["V4"])
