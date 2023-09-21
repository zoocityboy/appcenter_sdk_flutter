@echo off

echo "Installing hooks..."
copy /Y %cd%\.env\hooks\pre-commit.bash %cd%\.git\hooks\pre-commit
copy /Y %cd%\.env\hooks\pre-push.bash %cd%\.git\hooks\pre-push

echo "Done!"