#include <sys/types.h>
#include <sys/stat.h>
//#include <sys/mman.h>
#include "mman.h"
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <openssl/md5.h>

unsigned char result[MD5_DIGEST_LENGTH];

// Print the MD5 sum as hex-digits.
void print_md5_sum(unsigned char* md) {
    int i;
    for(i=0; i <MD5_DIGEST_LENGTH; i++) {
            printf("%02x",md[i]);
    }
}

// Get the size of the file by its file descriptor
unsigned long get_size_by_fd(int fd) {
    struct stat statbuf;
    if(fstat(fd, &statbuf) < 0) exit(-1);
    return statbuf.st_size;
}

int main(int argc, char *argv[]) {
    int file_descript;
    unsigned long file_size;
    char* file_buffer;

    if(argc != 2) { 
            printf("Must specify the file\n");
            exit(-1);
    }
    printf("using file:\t%s\n", argv[1]);

    file_descript = open(argv[1], O_RDONLY);
    if(file_descript < 0) exit(-1);

    file_size = get_size_by_fd(file_descript);
    printf("file size:\t%lu\n", file_size);

    file_buffer = mmap(0, file_size, PROT_READ, MAP_SHARED, file_descript, 0);
    MD5((unsigned char*) file_buffer, file_size, result);
    munmap(file_buffer, file_size); 

    print_md5_sum(result);
    printf("  %s\n", argv[1]);

    return 0;
}
