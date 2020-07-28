/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

#if defined(_WIN32)
 #include "stdio.h"
#endif
#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

#if defined(_WIN32)
 #include "stdio.h"
#endif
#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
extern void execute_2(char*, char *);
extern void execute_3(char*, char *);
extern void execute_4(char*, char *);
extern void execute_5(char*, char *);
extern void execute_6(char*, char *);
extern void execute_7(char*, char *);
extern void execute_8(char*, char *);
extern void execute_9(char*, char *);
extern void execute_95(char*, char *);
extern void execute_96(char*, char *);
extern void execute_97(char*, char *);
extern void execute_32(char*, char *);
extern void vlog_const_rhs_process_execute_0_fast_no_reg_no_agg(char*, char*, char*);
extern void execute_231(char*, char *);
extern void execute_232(char*, char *);
extern void execute_241(char*, char *);
extern void execute_242(char*, char *);
extern void execute_243(char*, char *);
extern void execute_244(char*, char *);
extern void execute_245(char*, char *);
extern void execute_247(char*, char *);
extern void execute_252(char*, char *);
extern void execute_253(char*, char *);
extern void execute_254(char*, char *);
extern void execute_255(char*, char *);
extern void execute_256(char*, char *);
extern void execute_35(char*, char *);
extern void execute_63(char*, char *);
extern void vlog_simple_process_execute_0_fast_no_reg_no_agg(char*, char*, char*);
extern void execute_135(char*, char *);
extern void execute_216(char*, char *);
extern void execute_217(char*, char *);
extern void execute_218(char*, char *);
extern void execute_219(char*, char *);
extern void execute_220(char*, char *);
extern void execute_221(char*, char *);
extern void execute_222(char*, char *);
extern void execute_44(char*, char *);
extern void execute_45(char*, char *);
extern void execute_46(char*, char *);
extern void execute_60(char*, char *);
extern void execute_61(char*, char *);
extern void execute_62(char*, char *);
extern void execute_148(char*, char *);
extern void execute_149(char*, char *);
extern void execute_150(char*, char *);
extern void execute_151(char*, char *);
extern void execute_152(char*, char *);
extern void execute_153(char*, char *);
extern void execute_154(char*, char *);
extern void execute_156(char*, char *);
extern void execute_157(char*, char *);
extern void execute_158(char*, char *);
extern void execute_159(char*, char *);
extern void execute_163(char*, char *);
extern void execute_167(char*, char *);
extern void execute_168(char*, char *);
extern void execute_169(char*, char *);
extern void execute_170(char*, char *);
extern void execute_171(char*, char *);
extern void execute_172(char*, char *);
extern void execute_175(char*, char *);
extern void execute_177(char*, char *);
extern void execute_178(char*, char *);
extern void execute_179(char*, char *);
extern void execute_180(char*, char *);
extern void execute_181(char*, char *);
extern void execute_182(char*, char *);
extern void execute_183(char*, char *);
extern void execute_184(char*, char *);
extern void execute_185(char*, char *);
extern void execute_186(char*, char *);
extern void execute_187(char*, char *);
extern void execute_188(char*, char *);
extern void execute_189(char*, char *);
extern void execute_190(char*, char *);
extern void execute_48(char*, char *);
extern void execute_49(char*, char *);
extern void execute_50(char*, char *);
extern void execute_51(char*, char *);
extern void execute_160(char*, char *);
extern void execute_161(char*, char *);
extern void execute_162(char*, char *);
extern void execute_53(char*, char *);
extern void execute_54(char*, char *);
extern void execute_55(char*, char *);
extern void execute_56(char*, char *);
extern void execute_164(char*, char *);
extern void execute_165(char*, char *);
extern void execute_166(char*, char *);
extern void execute_58(char*, char *);
extern void execute_59(char*, char *);
extern void execute_392(char*, char *);
extern void execute_393(char*, char *);
extern void execute_402(char*, char *);
extern void execute_403(char*, char *);
extern void execute_404(char*, char *);
extern void execute_405(char*, char *);
extern void execute_406(char*, char *);
extern void execute_408(char*, char *);
extern void execute_413(char*, char *);
extern void execute_414(char*, char *);
extern void execute_415(char*, char *);
extern void execute_416(char*, char *);
extern void execute_417(char*, char *);
extern void execute_66(char*, char *);
extern void execute_94(char*, char *);
extern void execute_296(char*, char *);
extern void execute_377(char*, char *);
extern void execute_378(char*, char *);
extern void execute_379(char*, char *);
extern void execute_380(char*, char *);
extern void execute_381(char*, char *);
extern void execute_382(char*, char *);
extern void execute_383(char*, char *);
extern void execute_75(char*, char *);
extern void execute_76(char*, char *);
extern void execute_77(char*, char *);
extern void execute_91(char*, char *);
extern void execute_92(char*, char *);
extern void execute_93(char*, char *);
extern void execute_309(char*, char *);
extern void execute_310(char*, char *);
extern void execute_311(char*, char *);
extern void execute_312(char*, char *);
extern void execute_313(char*, char *);
extern void execute_314(char*, char *);
extern void execute_315(char*, char *);
extern void execute_317(char*, char *);
extern void execute_318(char*, char *);
extern void execute_319(char*, char *);
extern void execute_320(char*, char *);
extern void execute_324(char*, char *);
extern void execute_328(char*, char *);
extern void execute_329(char*, char *);
extern void execute_330(char*, char *);
extern void execute_331(char*, char *);
extern void execute_332(char*, char *);
extern void execute_333(char*, char *);
extern void execute_336(char*, char *);
extern void execute_338(char*, char *);
extern void execute_339(char*, char *);
extern void execute_340(char*, char *);
extern void execute_341(char*, char *);
extern void execute_342(char*, char *);
extern void execute_343(char*, char *);
extern void execute_344(char*, char *);
extern void execute_345(char*, char *);
extern void execute_346(char*, char *);
extern void execute_347(char*, char *);
extern void execute_348(char*, char *);
extern void execute_349(char*, char *);
extern void execute_350(char*, char *);
extern void execute_351(char*, char *);
extern void vlog_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
extern void transaction_32(char*, char*, unsigned, unsigned, unsigned);
extern void vhdl_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
extern void transaction_36(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_37(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_38(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_39(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_40(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_41(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_42(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_43(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_45(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_46(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_47(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_48(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_49(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_374(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_375(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_376(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_377(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_378(char*, char*, unsigned, unsigned, unsigned);
funcp funcTab[175] = {(funcp)execute_2, (funcp)execute_3, (funcp)execute_4, (funcp)execute_5, (funcp)execute_6, (funcp)execute_7, (funcp)execute_8, (funcp)execute_9, (funcp)execute_95, (funcp)execute_96, (funcp)execute_97, (funcp)execute_32, (funcp)vlog_const_rhs_process_execute_0_fast_no_reg_no_agg, (funcp)execute_231, (funcp)execute_232, (funcp)execute_241, (funcp)execute_242, (funcp)execute_243, (funcp)execute_244, (funcp)execute_245, (funcp)execute_247, (funcp)execute_252, (funcp)execute_253, (funcp)execute_254, (funcp)execute_255, (funcp)execute_256, (funcp)execute_35, (funcp)execute_63, (funcp)vlog_simple_process_execute_0_fast_no_reg_no_agg, (funcp)execute_135, (funcp)execute_216, (funcp)execute_217, (funcp)execute_218, (funcp)execute_219, (funcp)execute_220, (funcp)execute_221, (funcp)execute_222, (funcp)execute_44, (funcp)execute_45, (funcp)execute_46, (funcp)execute_60, (funcp)execute_61, (funcp)execute_62, (funcp)execute_148, (funcp)execute_149, (funcp)execute_150, (funcp)execute_151, (funcp)execute_152, (funcp)execute_153, (funcp)execute_154, (funcp)execute_156, (funcp)execute_157, (funcp)execute_158, (funcp)execute_159, (funcp)execute_163, (funcp)execute_167, (funcp)execute_168, (funcp)execute_169, (funcp)execute_170, (funcp)execute_171, (funcp)execute_172, (funcp)execute_175, (funcp)execute_177, (funcp)execute_178, (funcp)execute_179, (funcp)execute_180, (funcp)execute_181, (funcp)execute_182, (funcp)execute_183, (funcp)execute_184, (funcp)execute_185, (funcp)execute_186, (funcp)execute_187, (funcp)execute_188, (funcp)execute_189, (funcp)execute_190, (funcp)execute_48, (funcp)execute_49, (funcp)execute_50, (funcp)execute_51, (funcp)execute_160, (funcp)execute_161, (funcp)execute_162, (funcp)execute_53, (funcp)execute_54, (funcp)execute_55, (funcp)execute_56, (funcp)execute_164, (funcp)execute_165, (funcp)execute_166, (funcp)execute_58, (funcp)execute_59, (funcp)execute_392, (funcp)execute_393, (funcp)execute_402, (funcp)execute_403, (funcp)execute_404, (funcp)execute_405, (funcp)execute_406, (funcp)execute_408, (funcp)execute_413, (funcp)execute_414, (funcp)execute_415, (funcp)execute_416, (funcp)execute_417, (funcp)execute_66, (funcp)execute_94, (funcp)execute_296, (funcp)execute_377, (funcp)execute_378, (funcp)execute_379, (funcp)execute_380, (funcp)execute_381, (funcp)execute_382, (funcp)execute_383, (funcp)execute_75, (funcp)execute_76, (funcp)execute_77, (funcp)execute_91, (funcp)execute_92, (funcp)execute_93, (funcp)execute_309, (funcp)execute_310, (funcp)execute_311, (funcp)execute_312, (funcp)execute_313, (funcp)execute_314, (funcp)execute_315, (funcp)execute_317, (funcp)execute_318, (funcp)execute_319, (funcp)execute_320, (funcp)execute_324, (funcp)execute_328, (funcp)execute_329, (funcp)execute_330, (funcp)execute_331, (funcp)execute_332, (funcp)execute_333, (funcp)execute_336, (funcp)execute_338, (funcp)execute_339, (funcp)execute_340, (funcp)execute_341, (funcp)execute_342, (funcp)execute_343, (funcp)execute_344, (funcp)execute_345, (funcp)execute_346, (funcp)execute_347, (funcp)execute_348, (funcp)execute_349, (funcp)execute_350, (funcp)execute_351, (funcp)vlog_transfunc_eventcallback, (funcp)transaction_32, (funcp)vhdl_transfunc_eventcallback, (funcp)transaction_36, (funcp)transaction_37, (funcp)transaction_38, (funcp)transaction_39, (funcp)transaction_40, (funcp)transaction_41, (funcp)transaction_42, (funcp)transaction_43, (funcp)transaction_45, (funcp)transaction_46, (funcp)transaction_47, (funcp)transaction_48, (funcp)transaction_49, (funcp)transaction_374, (funcp)transaction_375, (funcp)transaction_376, (funcp)transaction_377, (funcp)transaction_378};
const int NumRelocateId= 175;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/padding_tb_behav/xsim.reloc",  (void **)funcTab, 175);
	iki_vhdl_file_variable_register(dp + 145200);
	iki_vhdl_file_variable_register(dp + 145256);
	iki_vhdl_file_variable_register(dp + 151256);


	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/padding_tb_behav/xsim.reloc");
}

	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net

void wrapper_func_0(char *dp)

{

	iki_vlog_schedule_transaction_signal_fast_vhdl_value_time_0(dp + 150584, dp + 152824, 0, 0, 0, 0, 1, 1);

	iki_vlog_schedule_transaction_signal_fast_vhdl_value_time_0(dp + 150808, dp + 152880, 0, 0, 0, 0, 1, 1);

	iki_vlog_schedule_transaction_signal_fast_vhdl_value_time_0(dp + 150848, dp + 152936, 0, 9, 0, 9, 10, 1);

	iki_vlog_schedule_transaction_signal_fast_vhdl_value_time_0(dp + 150928, dp + 152992, 0, 7, 0, 7, 8, 1);

	iki_vlog_schedule_transaction_signal_fast_vhdl_value_time_0(dp + 150584, dp + 218608, 0, 0, 0, 0, 1, 1);

	iki_vlog_schedule_transaction_signal_fast_vhdl_value_time_0(dp + 150968, dp + 218664, 0, 0, 0, 0, 1, 1);

	iki_vlog_schedule_transaction_signal_fast_vhdl_value_time_0(dp + 151008, dp + 218720, 0, 9, 0, 9, 10, 1);

	iki_vlog_schedule_transaction_signal_fast_vhdl_value_time_0(dp + 151048, dp + 218776, 0, 7, 0, 7, 8, 1);

}

void simulate(char *dp)
{
		iki_schedule_processes_at_time_zero(dp, "xsim.dir/padding_tb_behav/xsim.reloc");
	wrapper_func_0(dp);

	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

extern SYSTEMCLIB_IMP_DLLSPEC void local_register_implicit_channel(int, char*);
extern void implicit_HDL_SCinstantiate();

extern void implicit_HDL_SCcleanup();

extern SYSTEMCLIB_IMP_DLLSPEC int xsim_argc_copy ;
extern SYSTEMCLIB_IMP_DLLSPEC char** xsim_argv_copy ;

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_sv_type_file_path_name("xsim.dir/padding_tb_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/padding_tb_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/padding_tb_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
