#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

extern void Main();

#define MAX_WORD_LENGTH 4 // Including null
#define NUM_WORDS 100 // Number of words

char* getRandomName() {
    // 100 three-letter words
    const char* words[NUM_WORDS] = {
        "cat\0", "dog\0", "bat\0", "rat\0", "hat\0", "mat\0", "pat\0", "sat\0", "fat\0", "eat\0",
        "pen\0", "fan\0", "van\0", "can\0", "pan\0", "man\0", "tan\0", "ran\0", "wan\0", "gan\0",
        "pot\0", "dot\0", "hot\0", "not\0", "got\0", "lot\0", "rot\0", "cot\0", "tot\0", "bot\0",
        "sun\0", "fun\0", "run\0", "bun\0", "pun\0", "gun\0", "hun\0", "tun\0", "dun\0", "mun\0",
        "cup\0", "pup\0", "sup\0", "mug\0", "rug\0", "tug\0", "jug\0", "bug\0", "hug\0", "dug\0",
        "lip\0", "rip\0", "hip\0", "tip\0", "sip\0", "zip\0", "yip\0", "nip\0", "kip\0", "mip\0",
      "map\0", "nap\0", "bap\0", "cap\0", "gap\0", "tap\0", "rap\0", "lap\0", "zap\0", "sap\0",
        "den\0", "pen\0", "hen\0", "fen\0", "men\0", "zen\0", "yen\0", "ten\0", "ken\0", "gen\0",
        "lid\0", "rid\0", "did\0", "kid\0", "hid\0", "bid\0", "mid\0", "tid\0", "sid\0", "fid\0",
        "bar\0", "car\0", "far\0", "jar\0", "mar\0", "tar\0", "yar\0", "zar\0", "sar\0", "dar\0"
    };

    // Generate a random index
    srand(time(NULL));
    int randomIndex = rand() % NUM_WORDS;

    // Allocate memory for  random name and copy the word
    char* randomName = (char*)malloc(MAX_WORD_LENGTH * sizeof(char));
    strcpy(randomName, words[randomIndex]);

    return randomName;
}

int main() {
    Main();
    return 0;
}
