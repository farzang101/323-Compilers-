
    /*
	Team Members: Farzan Ghaderpanah, Eric Van Der Roest, 	Jordan Wermuth, Arasto Abedi     */
	
    #include "LanguageParser.h"
    #include <fstream>
    #include <iostream>
    #include <cstdlib>
    #include <ctime>

    using namespace std;

    // Default Constructor
    // -> Namespace::Class
    LanguageParser::LanguageParser(){}

    // Handles full extent of input by calling four functions
    void LanguageParser::HandleInput()
    {
        ReadFile();
        RemoveComments();
        RemoveWhitespace();   // At this point 0 fat on input txt file
        AddSpacing();
    }

    // Read file into member variable 'rawData'
    void LanguageParser::ReadFile()
    {
        char current;  // value of current parse location
        
        while (dataFile.get(current))
            rawData += current;
    }

    // Remove comments, save result in member variable 'formattedInput'
    void LanguageParser::RemoveComments()
    {
        for (int i = 0; i < rawData.length(); i++)
        {
            switch(rawData.at(i))
            {
                case '(':
                    if (rawData.at(i + 1) != '*')           // Not a comment
                        formattedInput +=  rawData.at(i);   // Append the '(' value
                    else
                    {
                        while (!(rawData.at(i) == '*'))     // Check for 1st of 2 symbols that represent the closing comment
                            ++i;
                        while (!(rawData.at(i) == ')'))     // Check for 2nd of 2 symbols that represent the closing comment
                            ++i;

                        ++i;
                    }
                    
                    break;
                    
                default:
                    
                    formattedInput += rawData.at(i);
                    break;
            }
        }
    }

    // Remove whitespace, save result in member variable 'formattedInput'
    void LanguageParser::RemoveWhitespace()
    {
        string noWhitespace;
        
        for (int i = 0; i < formattedInput.length(); i++)
        {
            switch(formattedInput.at(i))
            {
                case ' ':
                case '\t':
                    break;
                    
                case ';':
                    if (formattedInput.at(i + 1) != '\n')
                    {
                        noWhitespace += formattedInput.at(i);
                        noWhitespace += '\n';
                        break;
                    }
                    else
                    {
                        noWhitespace += formattedInput.at(i);
                        break;
                    }
                    
                case '\n':
                    if (formattedInput.at(i - 1) == '\n')
                        break;
                    
                default:
                    noWhitespace += formattedInput.at(i);
                    break;
            }
        }
        
        formattedInput = noWhitespace;
    }

    // Add required spacing, save result in member variable 'formattedInput'
    void LanguageParser::AddSpacing()
    {
        string correctSpacing;
        
        correctSpacing += "  ";   // First line
        
        for (int i = 0; i < formattedInput.length(); i++)
        {
            switch(formattedInput.at(i))
            {
                case '\n':
                    correctSpacing += "\n  ";
                    break;
                    
                case ':':
                case '-':
                case '*':
                case '/':
                case '=':
                case '+':
                    
                    if  (isalnum(formattedInput.at(i - 1)) && isalnum(formattedInput.at(i + 1)))
                    {
                        correctSpacing += ' ';
                        correctSpacing += formattedInput.at(i);
                        correctSpacing += ' ';
                    }
                    else
                        correctSpacing += formattedInput.at(i);
                    
                    break;
                    
                case ',':
                    
                    correctSpacing += formattedInput.at(i);
                    
                    if (isalpha(formattedInput.at(i + 1)))
                        correctSpacing += ' ';
                    
                    break;
                    
                default:
                    
                    if (i > 6 && formattedInput.substr(i - 7, i) == "PROGRAM")
                        correctSpacing = correctSpacing + ' ';
                    
                    correctSpacing += formattedInput.at(i);
                    break;
            }
        }
        
        formattedInput = correctSpacing;
    }

    // Open File for input
    bool LanguageParser::OpenFileIn(string fileName){
        dataFile.open(fileName, ios::in);  // open fstream object for input
        return (!dataFile.fail());  // check if file is ready for input
    }

    // open File for output
    bool LanguageParser::OpenFileOut(string fileName){
        dataFile.open(fileName, std::ios_base::app);  // Open fstream obj for output (append mode)
        return (!dataFile.fail());  // Check if file is ready for output
    }

    // Write to file. If file isn't found, create it
    void LanguageParser::WriteFile(){
        if (dataFile)  // check if data file is open
            dataFile << formattedInput;
    }

    // Close file
    void LanguageParser::CloseFile(){
        dataFile.close();  // close current fstream object for input/output
    }

    // Flush file, causing stream buffer to flush its output buffer
    void LanguageParser::FlushFile(){
        dataFile.flush();
    }

    // Destructor
    LanguageParser::~LanguageParser(){}
