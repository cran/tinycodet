

x <- c(paste0(letters[1:13], collapse = ""),
       paste0(letters[14:26], collapse = ""))
print(x)
ss <- c(2, 3)
x %s><% ss

x <- c(paste0(letters[1:13], collapse = ""),
       paste0(letters[14:26], collapse = ""))
print(x)
ss <- c(1, 0)
x %s><% ss

x <- c(paste0(letters[1:13], collapse = ""),
       paste0(letters[14:26], collapse = ""))
print(x)
ss <- c(2, 3)
x %s<>% ss

x <- c(paste0(letters[1:13], collapse = ""),
       paste0(letters[14:26], collapse = ""))
print(x)
ss <- c(1, 0)
x %s<>% ss
