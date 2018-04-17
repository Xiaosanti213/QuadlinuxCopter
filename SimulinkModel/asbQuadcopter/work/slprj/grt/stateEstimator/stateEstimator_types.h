/*
 * stateEstimator_types.h
 *
 * Code generation for model "stateEstimator".
 *
 * Model version              : 1.65
 * Simulink Coder version : 8.12 (R2017a) 16-Feb-2017
 * C source code generated on : Mon Apr 16 08:51:32 2018
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Intel->x86-64 (Windows64)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef RTW_HEADER_stateEstimator_types_h_
#define RTW_HEADER_stateEstimator_types_h_
#include "rtwtypes.h"
#include "multiword_types.h"
#ifndef DEFINED_TYPEDEF_FOR_sensordata_t_
#define DEFINED_TYPEDEF_FOR_sensordata_t_

typedef struct {
  real32_T ddx;
  real32_T ddy;
  real32_T ddz;
  real32_T p;
  real32_T q;
  real32_T r;
} sensordata_t;

#endif

#ifndef DEFINED_TYPEDEF_FOR_statesEstim_t_
#define DEFINED_TYPEDEF_FOR_statesEstim_t_

typedef struct {
  real32_T yaw;
  real32_T pitch;
  real32_T roll;
  real32_T p;
  real32_T q;
  real32_T r;
} statesEstim_t;

#endif

/* Forward declaration for rtModel */
typedef struct tag_RTM_stateEstimator_T RT_MODEL_stateEstimator_T;

#endif                                 /* RTW_HEADER_stateEstimator_types_h_ */
