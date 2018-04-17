/*
 * Code generation for system model 'stateEstimator'
 * For more details, see corresponding source file stateEstimator.c
 *
 */

#ifndef RTW_HEADER_stateEstimator_h_
#define RTW_HEADER_stateEstimator_h_
#include <math.h>
#include <string.h>
#ifndef stateEstimator_COMMON_INCLUDES_
# define stateEstimator_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#endif                                 /* stateEstimator_COMMON_INCLUDES_ */

#include "stateEstimator_types.h"

/* Shared type includes */
#include "multiword_types.h"

/* Block signals for model 'stateEstimator' */
#ifndef stateEstimator_MDLREF_HIDE_CHILD_

typedef struct {
  real32_T inverseIMU_gain[6];         /* '<S3>/inverseIMU_gain' */
} B_stateEstimator_c_T;

#endif                                 /*stateEstimator_MDLREF_HIDE_CHILD_*/

/* Block states (auto storage) for model 'stateEstimator' */
#ifndef stateEstimator_MDLREF_HIDE_CHILD_

typedef struct {
  real32_T IIR_IMUgyro_r_states[5];    /* '<S3>/IIR_IMUgyro_r' */
  real32_T FIR_IMUaccel_states[15];    /* '<S3>/FIR_IMUaccel' */
  int32_T FIR_IMUaccel_circBuf;        /* '<S3>/FIR_IMUaccel' */
  real32_T Memory_PreviousInput[3];    /* '<S2>/Memory' */
  real32_T IIR_IMUgyro_r_tmp;          /* '<S3>/IIR_IMUgyro_r' */
} DW_stateEstimator_f_T;

#endif                                 /*stateEstimator_MDLREF_HIDE_CHILD_*/

#ifndef stateEstimator_MDLREF_HIDE_CHILD_

/* Real-time Model Data Structure */
struct tag_RTM_stateEstimator_T {
  const char_T **errorStatus;
};

#endif                                 /*stateEstimator_MDLREF_HIDE_CHILD_*/

#ifndef stateEstimator_MDLREF_HIDE_CHILD_

typedef struct {
  RT_MODEL_stateEstimator_T rtm;
} MdlrefDW_stateEstimator_T;

#endif                                 /*stateEstimator_MDLREF_HIDE_CHILD_*/

extern void stateEstimator_Init(void);
extern void stateEstimator_Reset(void);
extern void stateEstimator(const sensordata_t *rtu_sensordata_datin, const
  real32_T rtu_sensorCalibration_datin[7], statesEstim_t *rty_states_estimout);

/* Model reference registration function */
extern void stateEstimator_initialize(const char_T **rt_errorStatus);

#ifndef stateEstimator_MDLREF_HIDE_CHILD_

extern MdlrefDW_stateEstimator_T stateEstimator_MdlrefDW;

#endif                                 /*stateEstimator_MDLREF_HIDE_CHILD_*/

#ifndef stateEstimator_MDLREF_HIDE_CHILD_

/* Block signals (auto storage) */
extern B_stateEstimator_c_T stateEstimator_B;

/* Block states (auto storage) */
extern DW_stateEstimator_f_T stateEstimator_DW;

#endif                                 /*stateEstimator_MDLREF_HIDE_CHILD_*/

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'stateEstimator'
 * '<S1>'   : 'stateEstimator/State Estimator'
 * '<S2>'   : 'stateEstimator/State Estimator/Complementary Filter'
 * '<S3>'   : 'stateEstimator/State Estimator/SensorPreprocessing'
 * '<S4>'   : 'stateEstimator/State Estimator/Complementary Filter/If Action Subsystem'
 * '<S5>'   : 'stateEstimator/State Estimator/Complementary Filter/If Action Subsystem1'
 * '<S6>'   : 'stateEstimator/State Estimator/Complementary Filter/Wbe'
 * '<S7>'   : 'stateEstimator/State Estimator/Complementary Filter/Wbe/Create 3x3 Matrix'
 */
#endif                                 /* RTW_HEADER_stateEstimator_h_ */
