#include "factor.h"

XT primitives[] = {
	undefined,
	docol,
	primitive_execute,
	primitive_call,
	primitive_ifte,
	primitive_consp,
	primitive_cons,
	primitive_car,
	primitive_cdr,
	primitive_set_car,
	primitive_set_cdr,
	primitive_vectorp,
	primitive_vector,
	primitive_vector_length,
	primitive_set_vector_length,
	primitive_vector_nth,
	primitive_set_vector_nth,
	primitive_stringp,
	primitive_string_length,
	primitive_string_nth,
	primitive_string_compare,
	primitive_string_eq,
	primitive_string_hashcode,
	primitive_index_of,
	primitive_substring,
	primitive_string_reverse,
	primitive_sbufp,
	primitive_sbuf,
	primitive_sbuf_length,
	primitive_set_sbuf_length,
	primitive_sbuf_nth,
	primitive_set_sbuf_nth,
	primitive_sbuf_append,
	primitive_sbuf_to_string,
	primitive_sbuf_reverse,
	primitive_sbuf_clone,
	primitive_sbuf_eq,
	primitive_numberp,
	primitive_to_fixnum,
	primitive_to_bignum,
	primitive_to_float,
	primitive_number_eq,
	primitive_fixnump,
	primitive_bignump,
	primitive_ratiop,
	primitive_numerator,
	primitive_denominator,
	primitive_floatp,
	primitive_str_to_float,
	primitive_float_to_str,
	primitive_float_to_bits,
	primitive_complexp,
	primitive_real,
	primitive_imaginary,
	primitive_to_rect,
	primitive_from_rect,
	primitive_add,
	primitive_subtract,
	primitive_multiply,
	primitive_divint,
	primitive_divfloat,
	primitive_divide,
	primitive_mod,
	primitive_divmod,
	primitive_and,
	primitive_or,
	primitive_xor,
	primitive_not,
	primitive_shift,
	primitive_less,
	primitive_lesseq,
	primitive_greater,
	primitive_greatereq,
	primitive_facos,
	primitive_fasin,
	primitive_fatan,
        primitive_fatan2,
        primitive_fcos,
        primitive_fexp,
        primitive_fcosh,
        primitive_flog,
        primitive_fpow,
        primitive_fsin,
        primitive_fsinh,
        primitive_fsqrt,
	primitive_wordp,
	primitive_word,
	primitive_word_hashcode,
	primitive_word_xt,
	primitive_set_word_xt,
	primitive_word_primitive,
	primitive_set_word_primitive,
	primitive_word_parameter,
	primitive_set_word_parameter,
	primitive_word_plist,
	primitive_set_word_plist,
	primitive_drop,
	primitive_dup,
	primitive_swap,
	primitive_over,
	primitive_pick,
	primitive_nip,
	primitive_tuck,
	primitive_rot,
	primitive_to_r,
	primitive_from_r,
	primitive_eq,
	primitive_getenv,
	primitive_setenv,
	primitive_open_file,
	primitive_stat,
	primitive_read_dir,
	primitive_gc,
	primitive_save_image,
	primitive_datastack,
	primitive_callstack,
	primitive_set_datastack,
	primitive_set_callstack,
	primitive_portp,
	primitive_exit,
	primitive_client_socket,
	primitive_server_socket,
	primitive_close,
	primitive_add_accept_io_task,
	primitive_accept_fd,
	primitive_can_read_line,
	primitive_add_read_line_io_task,
	primitive_read_line_8,
	primitive_can_read_count,
	primitive_add_read_count_io_task,
	primitive_read_count_8,
	primitive_can_write,
	primitive_add_write_io_task,
	primitive_write_8,
	primitive_add_copy_io_task,
	primitive_pending_io_error,
	primitive_next_io_task,
	primitive_room,
	primitive_os_env,
	primitive_millis,
	primitive_init_random,
	primitive_random_int,
	primitive_type_of,
	primitive_size_of,
	primitive_call_profiling,
	primitive_word_call_count,
	primitive_set_word_call_count,
	primitive_allot_profiling,
	primitive_word_allot_count,
	primitive_set_word_allot_count,
	primitive_dump,
	primitive_cwd,
	primitive_cd,
	primitive_set_compiled_byte,
	primitive_set_compiled_cell,
	primitive_compiled_offset,
	primitive_set_compiled_offset,
	primitive_literal_top,
	primitive_set_literal_top,
	primitive_address_of,
	primitive_dlopen,
	primitive_dlsym,
	primitive_dlsym_self,
	primitive_dlclose
};

CELL primitive_to_xt(CELL primitive)
{
	if(primitive < 0 || primitive >= PRIMITIVE_COUNT)
		general_error(ERROR_BAD_PRIMITIVE,tag_fixnum(primitive));

	return (CELL)primitives[primitive];
}
