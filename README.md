# Depentree-cli

Collects your installed dependencies with versions and prints JSON object compatible for uploading to <http://depentree.com>.

## Run without installation

```
curl 'https://raw.githubusercontent.com/vti/depentree-cli/master/depentree.fatpack' | perl
```

## Usage example

### Submit directly to Depentree.com

```
$ cd my-perl-project/
$ export DEPENTREE_TOKEN=98f9f5b5147058d71ce2ba09ae91cacfd79f53c0
$ depentree --submit
Submitted
```

### Only print the results (for manual import)

```
$ cd my-perl-project/
$ depentree
[
   {
      "module" : "Class::Load",
      "version" : "0.24"
   },
   {
      "module" : "Config::Tiny",
      "version" : "2.23"
   },
   {
      "module" : "File::chdir",
      "version" : "0.1010"
   },
   {
      "module" : "JSON",
      "version" : "2.94"
   },
   {
      "module" : "Module::CPANfile",
      "version" : "1.1002"
   }
]
```
