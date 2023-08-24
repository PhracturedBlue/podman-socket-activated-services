#include <stdlib.h>
#include <stdio.h>
#include <strings.h>
#include<unistd.h>

// This is a hack to move filehandle 3 to filehandle 0 to emulate inetd from a socket-activated socket

int main(int argc, char * const argv[]) {
    char cmd[1024];
    char *args[argc];
    for (int i = 1; i < argc; i++) {
        args[i-1] = argv[i];
    }
    args[argc-1] = NULL;
    close(0);
    dup(3);
    close(3);
    unsetenv("LISTEN_FDS");
    unsetenv("LISTEN_PID");
    execvp(args[0], args);
}
