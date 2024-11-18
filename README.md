#!/bin/bash

echo "======================================="
echo "  Checking if SonarLint is installed..."
echo "======================================="

# Detect the type of application based on files in the repository
if [ -f "app.py" ] || [ -f "requirements.txt" ]; then
    APP_TYPE="python"
elif [ -f "*.csproj" ]; then
    APP_TYPE="dotnet"
elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
    APP_TYPE="java"
else
    echo "Could not detect the application type. Please ensure the script is run in the correct repository."
    exit 1
fi

# Function to check for SonarLint in Python
check_python_sonarlint() {
    echo "Detected Python application. Checking for SonarLint..."
    if python -m pip show sonarlint &>/dev/null; then
        echo "SonarLint is installed for Python."
    else
        echo "SonarLint is not installed for Python. Install it using:"
        echo "    pip install sonarlint"
        exit 1
    fi
    echo "Running the application..."
    python app.py  # Adjust to your main application file
}

# Function to check for SonarLint in .NET
check_dotnet_sonarlint() {
    echo "Detected .NET application. Checking for SonarLint..."
    SONARLINT_PATH="$env:LOCALAPPDATA/Microsoft/VisualStudio/Extensions"

    if [ -d "$SONARLINT_PATH" ] && find "$SONARLINT_PATH" -name "SonarLint*" &>/dev/null; then
        echo "SonarLint is installed for .NET."
    else
        echo "SonarLint is not installed for .NET. Please install it from the Visual Studio Marketplace."
        exit 1
    fi
    echo "Running the application..."
    dotnet run
}

# Function to check for SonarLint in Java
check_java_sonarlint() {
    echo "Detected Java application. Checking for SonarLint..."
    SONARLINT_PATH="$HOME/.IdeaIC*/config/plugins/SonarLint"

    if [ -d "$SONARLINT_PATH" ]; then
        echo "SonarLint is installed for Java."
    else
        echo "SonarLint is not installed for Java. Please install it as an IntelliJ IDEA plugin."
        exit 1
    fi
    echo "Running the application..."
    ./gradlew run || mvn exec:java  # Adjust to your build tool
}

# Execute the appropriate function based on application type
case $APP_TYPE in
    python)
        check_python_sonarlint
        ;;
    dotnet)
        check_dotnet_sonarlint
        ;;
    java)
        check_java_sonarlint
        ;;
    *)
        echo "Unsupported application type."
        exit 1
        ;;
esac
