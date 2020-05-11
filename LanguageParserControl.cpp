
    /*
	Team Members: Farzan Ghaderpanah, Eric Van Der Roest, 	Jordan Wermuth, Arasto Abedi     */

    #include <iostream>   // C++ library imports
    #include <fstream>
    #include <string>

    #include "LanguageParser.h"   // Custom class imports

    using namespace std;

    bool FileExists(string inputFileName);   // Declarations
    bool FileContainsContent(string inputFileName);
    void ParseHandler ();
    bool exist(std::string filename) ;   //Function to check if file exists


    LanguageParser langParserInstance;   // Single instance obj, namespace: 'Parser'

    int main()   // Entry point
    {
        if(exist("revised.txt"))
            remove("revised.txt");
        
        if (langParserInstance.OpenFileIn("final.txt"))
        {
            langParserInstance.HandleInput();
            
            langParserInstance.CloseFile();
            langParserInstance.OpenFileOut("revised.txt");
            langParserInstance.WriteFile();
        }
        
        return 0;   // Exit point
    }

    bool exist(std::string filename)
    {
        bool result;
        std::ifstream infile;
        infile.open(filename);
        result = (infile ? true : false);   //If infile could be opened, it exists so RETURN TRUE, else RETURN FALSE
        infile.close();
        return result;
    }
