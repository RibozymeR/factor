#define ERROR_PORT_EXPIRED (0<<3)
#define ERROR_IO_TASK_TWICE (1<<3)
#define ERROR_IO_TASK_NONE (2<<3)
#define ERROR_INCOMPATIBLE_PORT (3<<3)
#define ERROR_IO (4<<3)
#define ERROR_UNDEFINED_WORD (5<<3)
#define ERROR_TYPE (6<<3)
#define ERROR_RANGE (7<<3)
#define ERROR_INCOMPARABLE (8<<3)
#define ERROR_FLOAT_FORMAT (9<<3)
#define ERROR_SIGNAL (10<<3)
#define ERROR_PROFILING_DISABLED (11<<3)
#define ERROR_NEGATIVE_ARRAY_SIZE (12<<3)
#define ERROR_BAD_PRIMITIVE (13<<3)
#define ERROR_C_STRING (14<<3)
#define ERROR_FFI_DISABLED (15<<3)
#define ERROR_FFI (16<<3)

void fatal_error(char* msg, CELL tagged);
void critical_error(char* msg, CELL tagged);
void fix_stacks(void);
void throw_error(CELL object);
void general_error(CELL error, CELL tagged);
void type_error(CELL type, CELL tagged);
void range_error(CELL tagged, CELL index, CELL max);
