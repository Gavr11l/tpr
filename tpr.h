char lcd_buffer[8];  // variable for format display number values 
unsigned char display_buffer[17];
unsigned char hour, minutes, sec; //часы, минуты, секунды
unsigned char day, month, year, weekDay; //день, месяц, год
unsigned char tempSymbols[4];
unsigned char devices;

// maximum number of DS1820 / DS18S20 / DS18B20 connected to the 1 Wire bus
#define MAX_DEVICES 4

// DS1820 / DS18S20 / DS18B20 devices ROM code storage area
unsigned char rom_code[MAX_DEVICES][9];

