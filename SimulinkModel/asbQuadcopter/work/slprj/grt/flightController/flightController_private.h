/*
 * flightController_private.h
 *
 * Code generation for model "flightController".
 *
 * Model version              : 1.120
 * Simulink Coder version : 8.12 (R2017a) 16-Feb-2017
 * C source code generated on : Mon Apr 16 08:51:11 2018
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Intel->x86-64 (Windows64)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef RTW_HEADER_flightController_private_h_
#define RTW_HEADER_flightController_private_h_
#include "rtwtypes.h"
#include "multiword_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        (*((rtm)->errorStatus))
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   (*((rtm)->errorStatus) = (val))
#endif

#ifndef rtmGetErrorStatusPointer
# define rtmGetErrorStatusPointer(rtm) (rtm)->errorStatus
#endif

#ifndef rtmSetErrorStatusPointer
# define rtmSetErrorStatusPointer(rtm, val) ((rtm)->errorStatus = (val))
#endif

extern const real32_T rtCP_pooled_AiPFoGkd3zrs[16];
extern const real32_T rtCP_pooled_oEBofkCxx3u4[4];

#define rtCP_TorquetotalThrustToThrustperMotor_Value rtCP_pooled_AiPFoGkd3zrs/* Computed Parameter: rtCP_TorquetotalThrustToThrustperMotor_Value
                                                                      * Referenced by: '<S3>/TorquetotalThrustToThrustperMotor'
                                                                      */
#define rtCP_Motordirections1_Gain     rtCP_pooled_oEBofkCxx3u4  /* Computed Parameter: rtCP_Motordirections1_Gain
                                                                  * Referenced by: '<S5>/Motordirections1'
                                                                  */
#endif                                 /* RTW_HEADER_flightController_private_h_ */
