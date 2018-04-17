/*
 * test_utility.c
 *
 * Code generation for model "test_utility".
 *
 * Model version              : 1.2
 * Simulink Coder version : 8.12 (R2017a) 16-Feb-2017
 * C source code generated on : Sat Apr 14 22:32:04 2018
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Intel->x86-64 (Windows64)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "test_utility.h"
#include "test_utility_private.h"

/* Block signals (auto storage) */
B_test_utility_T test_utility_B;

/* Block states (auto storage) */
DW_test_utility_T test_utility_DW;

/* Real-time model */
RT_MODEL_test_utility_T test_utility_M_;
RT_MODEL_test_utility_T *const test_utility_M = &test_utility_M_;

/* Model step function */
void test_utility_step(void)
{
  /* Sin: '<Root>/Sine Wave' */
  test_utility_B.SineWave = sin(test_utility_P.SineWave_Freq *
    test_utility_M->Timing.t[0] + test_utility_P.SineWave_Phase) *
    test_utility_P.SineWave_Amp + test_utility_P.SineWave_Bias;

  /* Matfile logging */
  rt_UpdateTXYLogVars(test_utility_M->rtwLogInfo, (test_utility_M->Timing.t));

  /* signal main to stop simulation */
  {                                    /* Sample time: [0.0s, 0.0s] */
    if ((rtmGetTFinal(test_utility_M)!=-1) &&
        !((rtmGetTFinal(test_utility_M)-test_utility_M->Timing.t[0]) >
          test_utility_M->Timing.t[0] * (DBL_EPSILON))) {
      rtmSetErrorStatus(test_utility_M, "Simulation finished");
    }
  }

  /* Update absolute time for base rate */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick0"
   * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
   * overflow during the application lifespan selected.
   * Timer of this task consists of two 32 bit unsigned integers.
   * The two integers represent the low bits Timing.clockTick0 and the high bits
   * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
   */
  if (!(++test_utility_M->Timing.clockTick0)) {
    ++test_utility_M->Timing.clockTickH0;
  }

  test_utility_M->Timing.t[0] = test_utility_M->Timing.clockTick0 *
    test_utility_M->Timing.stepSize0 + test_utility_M->Timing.clockTickH0 *
    test_utility_M->Timing.stepSize0 * 4294967296.0;

  {
    /* Update absolute timer for sample time: [0.2s, 0.0s] */
    /* The "clockTick1" counts the number of times the code of this task has
     * been executed. The resolution of this integer timer is 0.2, which is the step size
     * of the task. Size of "clockTick1" ensures timer will not overflow during the
     * application lifespan selected.
     * Timer of this task consists of two 32 bit unsigned integers.
     * The two integers represent the low bits Timing.clockTick1 and the high bits
     * Timing.clockTickH1. When the low bit overflows to 0, the high bits increment.
     */
    test_utility_M->Timing.clockTick1++;
    if (!test_utility_M->Timing.clockTick1) {
      test_utility_M->Timing.clockTickH1++;
    }
  }
}

/* Model initialize function */
void test_utility_initialize(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize real-time model */
  (void) memset((void *)test_utility_M, 0,
                sizeof(RT_MODEL_test_utility_T));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&test_utility_M->solverInfo,
                          &test_utility_M->Timing.simTimeStep);
    rtsiSetTPtr(&test_utility_M->solverInfo, &rtmGetTPtr(test_utility_M));
    rtsiSetStepSizePtr(&test_utility_M->solverInfo,
                       &test_utility_M->Timing.stepSize0);
    rtsiSetErrorStatusPtr(&test_utility_M->solverInfo, (&rtmGetErrorStatus
      (test_utility_M)));
    rtsiSetRTModelPtr(&test_utility_M->solverInfo, test_utility_M);
  }

  rtsiSetSimTimeStep(&test_utility_M->solverInfo, MAJOR_TIME_STEP);
  rtsiSetSolverName(&test_utility_M->solverInfo,"FixedStepDiscrete");
  rtmSetTPtr(test_utility_M, &test_utility_M->Timing.tArray[0]);
  rtmSetTFinal(test_utility_M, 10.0);
  test_utility_M->Timing.stepSize0 = 0.2;

  /* Setup for data logging */
  {
    static RTWLogInfo rt_DataLoggingInfo;
    rt_DataLoggingInfo.loggingInterval = NULL;
    test_utility_M->rtwLogInfo = &rt_DataLoggingInfo;
  }

  /* Setup for data logging */
  {
    rtliSetLogXSignalInfo(test_utility_M->rtwLogInfo, (NULL));
    rtliSetLogXSignalPtrs(test_utility_M->rtwLogInfo, (NULL));
    rtliSetLogT(test_utility_M->rtwLogInfo, "tout");
    rtliSetLogX(test_utility_M->rtwLogInfo, "");
    rtliSetLogXFinal(test_utility_M->rtwLogInfo, "");
    rtliSetLogVarNameModifier(test_utility_M->rtwLogInfo, "rt_");
    rtliSetLogFormat(test_utility_M->rtwLogInfo, 4);
    rtliSetLogMaxRows(test_utility_M->rtwLogInfo, 0);
    rtliSetLogDecimation(test_utility_M->rtwLogInfo, 1);
    rtliSetLogY(test_utility_M->rtwLogInfo, "");
    rtliSetLogYSignalInfo(test_utility_M->rtwLogInfo, (NULL));
    rtliSetLogYSignalPtrs(test_utility_M->rtwLogInfo, (NULL));
  }

  /* block I/O */
  (void) memset(((void *) &test_utility_B), 0,
                sizeof(B_test_utility_T));

  /* states (dwork) */
  (void) memset((void *)&test_utility_DW, 0,
                sizeof(DW_test_utility_T));

  /* Matfile logging */
  rt_StartDataLoggingWithStartTime(test_utility_M->rtwLogInfo, 0.0, rtmGetTFinal
    (test_utility_M), test_utility_M->Timing.stepSize0, (&rtmGetErrorStatus
    (test_utility_M)));
}

/* Model terminate function */
void test_utility_terminate(void)
{
  /* (no terminate code required) */
}
