#ifdef BUILD_DLL
 #define MINHADLL __declspec(dllexport)
#else
 #define MINHADLL __declspec(dllimport)
#endif
 
MINHADLL callCmd();