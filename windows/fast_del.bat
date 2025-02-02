@echo off
echo Deleting %*...
del /f/s/q %* > nul
rmdir /s/q %*
