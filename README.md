# Scripts o procedimientos genéricos para GNU/Linux

## dirLowercase.hs

Procedimiento en Haskell para llevar a lowercase los archivos de un directorio específico. De momento tienes que tener instalado Haskell en tu plataforma y cargar el script.
Lo importante aquí es que el tipo "FilePath" es un alias para "String", por ello se puede usar "toLower" del módulo "Data.Char"

### Uso 

```bash
ghci
```

```haskell
:l dirLowercase
changeFilename "/home/user/somedir"
```
