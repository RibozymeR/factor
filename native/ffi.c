#include "factor.h"

void primitive_dlopen(void)
{
#ifdef FFI
	char* path = unbox_c_string();
	void* dllptr = dlopen(path,RTLD_LAZY);
	DLL* dll;

	if(dllptr == NULL)
	{
		general_error(ERROR_FFI,tag_object(
			from_c_string(dlerror())));
	}

	dll = allot_object(DLL_TYPE,sizeof(DLL));
	dll->dll = dllptr;
	dpush(tag_object(dll));
#else
	general_error(ERROR_FFI_DISABLED,F);
#endif
}

void primitive_dlsym(void)
{
#ifdef FFI
	DLL* dll = untag_dll(dpop());
	void* sym = dlsym(dll->dll,unbox_c_string());
	if(sym == NULL)
	{
		general_error(ERROR_FFI,tag_object(
			from_c_string(dlerror())));
	}
	dpush(tag_cell((CELL)sym));
#else
	general_error(ERROR_FFI_DISABLED,F);
#endif
}

void primitive_dlsym_self(void)
{
#ifdef FFI
	void* sym = dlsym(NULL,unbox_c_string());
	if(sym == NULL)
	{
		general_error(ERROR_FFI,tag_object(
			from_c_string(dlerror())));
	}
	dpush(tag_cell((CELL)sym));
#else
	general_error(ERROR_FFI_DISABLED,F);
#endif
}

void primitive_dlclose(void)
{
#ifdef FFI
	DLL* dll = untag_dll(dpop());
	if(dlclose(dll->dll) == -1)
	{
		general_error(ERROR_FFI,tag_object(
			from_c_string(dlerror())));
	}
	dll->dll = NULL;
#else
	general_error(ERROR_FFI_DISABLED,F);
#endif
}

void primitive_alien(void)
{
#ifdef FFI
	CELL length = unbox_integer();
	CELL ptr = unbox_integer();
	ALIEN* alien = allot_object(ALIEN_TYPE,sizeof(ALIEN));
	alien->ptr = ptr;
	alien->length = length;
	dpush(tag_object(alien));
#else
	general_error(ERROR_FFI_DISABLED,F);
#endif
}

ALIEN* unbox_alien(void)
{
	return untag_alien(dpop())->ptr;
}

INLINE CELL alien_pointer(void)
{
	FIXNUM offset = unbox_integer();
	ALIEN* alien = untag_alien(dpop());
	if(offset < 0 || offset >= alien->length)
	{
		range_error(tag_object(alien),offset,alien->length);
		return 0; /* can't happen */
	}
	else
		return alien->ptr + offset;
}

void primitive_alien_cell(void)
{
#ifdef FFI
	box_integer(get(alien_pointer()));
#else
	general_error(ERROR_FFI_DISABLED,F);
#endif
}

void primitive_set_alien_cell(void)
{
#ifdef FFI
	CELL ptr = alien_pointer();
	CELL value = unbox_integer();
	put(ptr,value);
#else
	general_error(ERROR_FFI_DISABLED,F);
#endif
}

void primitive_alien_4(void)
{
#ifdef FFI
	CELL ptr = alien_pointer();
	box_integer(*(int*)ptr);
#else
	general_error(ERROR_FFI_DISABLED,F);
#endif
}

void primitive_set_alien_4(void)
{
#ifdef FFI
	CELL ptr = alien_pointer();
	CELL value = unbox_integer();
	*(int*)ptr = value;
#else
	general_error(ERROR_FFI_DISABLED,F);
#endif
}

void primitive_alien_2(void)
{
#ifdef FFI
	CELL ptr = alien_pointer();
	box_integer(*(CHAR*)ptr);
#else
	general_error(ERROR_FFI_DISABLED,F);
#endif
}

void primitive_set_alien_2(void)
{
#ifdef FFI
	CELL ptr = alien_pointer();
	CELL value = unbox_integer();
	*(CHAR*)ptr = value;
#else
	general_error(ERROR_FFI_DISABLED,F);
#endif
}

void primitive_alien_1(void)
{
#ifdef FFI
	box_integer(bget(alien_pointer()));
#else
	general_error(ERROR_FFI_DISABLED,F);
#endif
}

void primitive_set_alien_1(void)
{
#ifdef FFI
	CELL ptr = alien_pointer();
	BYTE value = value = unbox_integer();
	bput(ptr,value);
#else
	general_error(ERROR_FFI_DISABLED,F);
#endif
}
