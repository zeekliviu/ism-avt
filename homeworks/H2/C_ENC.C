#include <stdio.h>
#include <time.h>

const char *KEY_FILE = "c_enc.key";
const char *INPUT_FILE = "dummy.txt";
const char *OUTPUT_FILE = "c_enc.fl";
const char *DECRYPTED_FILE = "c_dec.txt";

unsigned char getRandomByte();
void saveKeyToFile(unsigned char key, const char *filename);
void encryptFile(const char *inputFilename, const char *outputFilename, unsigned char key);
void decryptFile(const char *inputFilename, const char *outputFilename, unsigned char key);

void main()
{
    unsigned char randomKey = getRandomByte();
    saveKeyToFile(randomKey, KEY_FILE);
    encryptFile(INPUT_FILE, OUTPUT_FILE, randomKey);
}

unsigned char getRandomByte()
{
    time_t seconds = time(NULL);
    unsigned char randomByte = (unsigned char)(seconds % 60);
    return randomByte;
}

void saveKeyToFile(unsigned char key, const char *filename)
{
    FILE *file = fopen(filename, "w");
    if (file == NULL)
    {
        printf("Error opening file!\n");
        return;
    }

    fprintf(file, "%c", key);
    fclose(file);
}

void encryptFile(const char *inputFilename, const char *outputFilename, unsigned char key)
{
    FILE *inputFile = fopen(inputFilename, "r");
    FILE *outputFile = fopen(outputFilename, "w");
    char c;

    if (inputFile == NULL || outputFile == NULL)
    {
        printf("Error opening file!\n");
        return;
    }

    while ((c = fgetc(inputFile)) != EOF)
    {
        c = c ^ key;
        fputc(c, outputFile);
    }

    fclose(inputFile);
    fclose(outputFile);
}

void decryptFile(const char *inputFilename, const char *outputFilename, unsigned char key)
{
    FILE *inputFile = fopen(inputFilename, "r");
    FILE *outputFile = fopen(outputFilename, "w");
    char c;

    if (inputFile == NULL || outputFile == NULL)
    {
        printf("Error opening file!\n");
        return;
    }

    while ((c = fgetc(inputFile)) != EOF)
    {
        c = c ^ key;
        fputc(c, outputFile);
    }

    fclose(inputFile);
    fclose(outputFile);
}