If errors like following are seen while installing Mono -

```bash
The following packages have unmet dependencies:
 mono-complete : Depends: mono-runtime (= 4.2.1.102+dfsg2-7ubuntu4) but it is not going to be installed
                 Depends: mono-runtime-sgen (= 4.2.1.102+dfsg2-7ubuntu4) but it is not going to be installed
                 Depends: mono-utils (= 4.2.1.102+dfsg2-7ubuntu4) but it is not going to be installed
                 Depends: mono-devel (= 4.2.1.102+dfsg2-7ubuntu4) but it is not going to be installed
                 Depends: mono-mcs (= 4.2.1.102+dfsg2-7ubuntu4) but it is not going to be installed
                 Depends: mono-csharp-shell (= 4.2.1.102+dfsg2-7ubuntu4) but it is not going to be installed
                 Depends: mono-4.0-gac (= 4.2.1.102+dfsg2-7ubuntu4) but it is not going to be installed
                 Depends: mono-4.0-service (= 4.2.1.102+dfsg2-7ubuntu4) but it is not going to be installed
                 Depends: monodoc-base (= 4.2.1.102+dfsg2-7ubuntu4) but it is not going to be installed
                 Depends: monodoc-manual (= 4.2.1.102+dfsg2-7ubuntu4) but 4.2.3.4-0xamarin2 is to be installed
                 Depends: libmono-cil-dev (= 4.2.1.102+dfsg2-7ubuntu4) but it is not going to be installed
                 Depends: ca-certificates-mono (= 4.2.1.102+dfsg2-7ubuntu4) but it is not going to be installed
E: Unable to correct problems, you have held broken packages.
```

Try using Aptitude to resolve dependency issues -
```bash
sudo aptitude install mono-complete
```
OR
```bash
sudo apt install mono-complete
```
