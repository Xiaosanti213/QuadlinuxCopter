/*
 * Code generation for system model 'stateEstimator'
 *
 * Model                      : stateEstimator
 * Model version              : 1.65
 * Simulink Coder version : 8.12 (R2017a) 16-Feb-2017
 * C source code generated on : Mon Apr 16 08:51:32 2018
 *
 * Note that the functions contained in this file are part of a Simulink
 * model, and are not self-contained algorithms.
 */

#include "stateEstimator.h"
#include "stateEstimator_private.h"

MdlrefDW_stateEstimator_T stateEstimator_MdlrefDW;

/* Block signals (auto storage) */
B_stateEstimator_c_T stateEstimator_B;

/* Block states (auto storage) */
DW_stateEstimator_f_T stateEstimator_DW;

/* System initialize for referenced model: 'stateEstimator' */
void stateEstimator_Init(void)
{
  int32_T i;

  /* InitializeConditions for Memory: '<S2>/Memory' */
  stateEstimator_DW.Memory_PreviousInput[0] = 0.0F;
  stateEstimator_DW.Memory_PreviousInput[1] = 0.0F;
  stateEstimator_DW.Memory_PreviousInput[2] = 0.0F;

  /* InitializeConditions for DiscreteFilter: '<S3>/IIR_IMUgyro_r' */
  for (i = 0; i < 5; i++) {
    stateEstimator_DW.IIR_IMUgyro_r_states[i] = 0.0F;
  }

  /* End of InitializeConditions for DiscreteFilter: '<S3>/IIR_IMUgyro_r' */

  /* InitializeConditions for DiscreteFir: '<S3>/FIR_IMUaccel' */
  stateEstimator_DW.FIR_IMUaccel_circBuf = 0;
  for (i = 0; i < 15; i++) {
    stateEstimator_DW.FIR_IMUaccel_states[i] = 0.0F;
  }

  /* End of InitializeConditions for DiscreteFir: '<S3>/FIR_IMUaccel' */
}

/* System reset for referenced model: 'stateEstimator' */
void stateEstimator_Reset(void)
{
  int32_T i;

  /* InitializeConditions for Memory: '<S2>/Memory' */
  stateEstimator_DW.Memory_PreviousInput[0] = 0.0F;
  stateEstimator_DW.Memory_PreviousInput[1] = 0.0F;
  stateEstimator_DW.Memory_PreviousInput[2] = 0.0F;

  /* InitializeConditions for DiscreteFilter: '<S3>/IIR_IMUgyro_r' */
  for (i = 0; i < 5; i++) {
    stateEstimator_DW.IIR_IMUgyro_r_states[i] = 0.0F;
  }

  /* End of InitializeConditions for DiscreteFilter: '<S3>/IIR_IMUgyro_r' */

  /* InitializeConditions for DiscreteFir: '<S3>/FIR_IMUaccel' */
  stateEstimator_DW.FIR_IMUaccel_circBuf = 0;
  for (i = 0; i < 15; i++) {
    stateEstimator_DW.FIR_IMUaccel_states[i] = 0.0F;
  }

  /* End of InitializeConditions for DiscreteFir: '<S3>/FIR_IMUaccel' */
}

/* Output and update for referenced model: 'stateEstimator' */
void stateEstimator(const sensordata_t *rtu_sensordata_datin, const real32_T
                    rtu_sensorCalibration_datin[7], statesEstim_t
                    *rty_states_estimout)
{
  int32_T memIdx;
  int32_T j;
  real32_T rtb_VectorConcatenate[9];
  real32_T rtb_Product[3];
  real32_T rtb_VectorConcatenate_0[9];
  real32_T rtb_TrigonometricFunction_o2_idx_1;
  real32_T rtb_TrigonometricFunction_o1_idx_0;
  real32_T rtb_TrigonometricFunction_o2_idx_0;
  real32_T rtb_TrigonometricFunction_o1_idx_1;
  real32_T rtb_FIR_IMUaccel_idx_0;

  /* SignalConversion: '<S7>/ConcatBufferAtVector ConcatenateIn1' incorporates:
   *  Constant: '<S6>/Constant'
   */
  rtb_VectorConcatenate[0] = 0.0F;

  /* SignalConversion: '<S7>/ConcatBufferAtVector ConcatenateIn2' incorporates:
   *  Constant: '<S6>/Constant'
   */
  rtb_VectorConcatenate[1] = 0.0F;

  /* Trigonometry: '<S6>/Trigonometric Function' incorporates:
   *  Memory: '<S2>/Memory'
   *  SignalConversion: '<S6>/TmpSignal ConversionAtTrigonometric FunctionInport1'
   */
  rtb_TrigonometricFunction_o1_idx_0 = (real32_T)sin
    (stateEstimator_DW.Memory_PreviousInput[2]);
  rtb_TrigonometricFunction_o2_idx_0 = (real32_T)cos
    (stateEstimator_DW.Memory_PreviousInput[2]);
  rtb_TrigonometricFunction_o1_idx_1 = (real32_T)sin
    (stateEstimator_DW.Memory_PreviousInput[1]);
  rtb_TrigonometricFunction_o2_idx_1 = (real32_T)cos
    (stateEstimator_DW.Memory_PreviousInput[1]);

  /* SignalConversion: '<S7>/ConcatBufferAtVector ConcatenateIn3' */
  rtb_VectorConcatenate[2] = rtb_TrigonometricFunction_o2_idx_1;

  /* SignalConversion: '<S7>/ConcatBufferAtVector ConcatenateIn4' */
  rtb_VectorConcatenate[3] = rtb_TrigonometricFunction_o1_idx_0;

  /* Product: '<S6>/Product1' */
  rtb_VectorConcatenate[4] = rtb_TrigonometricFunction_o2_idx_0 *
    rtb_TrigonometricFunction_o2_idx_1;

  /* Product: '<S6>/Product3' */
  rtb_VectorConcatenate[5] = rtb_TrigonometricFunction_o1_idx_0 *
    rtb_TrigonometricFunction_o1_idx_1;

  /* SignalConversion: '<S7>/ConcatBufferAtVector ConcatenateIn7' */
  rtb_VectorConcatenate[6] = rtb_TrigonometricFunction_o2_idx_0;

  /* Product: '<S6>/Product2' incorporates:
   *  Gain: '<S6>/Gain'
   */
  rtb_VectorConcatenate[7] = (-1.0F) * rtb_TrigonometricFunction_o1_idx_0 *
    rtb_TrigonometricFunction_o2_idx_1;

  /* Product: '<S6>/Product4' */
  rtb_VectorConcatenate[8] = rtb_TrigonometricFunction_o2_idx_0 *
    rtb_TrigonometricFunction_o1_idx_1;

  /* Gain: '<S3>/inverseIMU_gain' incorporates:
   *  Bias: '<S3>/Assuming that calib was done level!'
   *  DataTypeConversion: '<S3>/Data Type Conversion'
   *  Sum: '<S3>/Sum1'
   */
  stateEstimator_B.inverseIMU_gain[0] = (rtu_sensordata_datin->ddx -
    (rtu_sensorCalibration_datin[0] + 0.0F)) * 0.994075298F;
  stateEstimator_B.inverseIMU_gain[1] = (rtu_sensordata_datin->ddy -
    (rtu_sensorCalibration_datin[1] + 0.0F)) * 0.996184587F;
  stateEstimator_B.inverseIMU_gain[2] = (rtu_sensordata_datin->ddz -
    (rtu_sensorCalibration_datin[2] + 9.81F)) * 1.00549F;
  stateEstimator_B.inverseIMU_gain[3] = (rtu_sensordata_datin->p -
    (rtu_sensorCalibration_datin[3] + 0.0F)) * 1.00139189F;
  stateEstimator_B.inverseIMU_gain[4] = (rtu_sensordata_datin->q -
    (rtu_sensorCalibration_datin[4] + 0.0F)) * 0.993601203F;
  stateEstimator_B.inverseIMU_gain[5] = (rtu_sensordata_datin->r -
    (rtu_sensorCalibration_datin[5] + 0.0F)) * 1.00003F;

  /* DiscreteFilter: '<S3>/IIR_IMUgyro_r' incorporates:
   *  Update for DiscreteFilter: '<S3>/IIR_IMUgyro_r'
   *  DiscreteFir: '<S3>/FIR_IMUaccel'
   */
  stateEstimator_DW.IIR_IMUgyro_r_tmp = 0.0F;
  rtb_TrigonometricFunction_o2_idx_0 = stateEstimator_B.inverseIMU_gain[5] -
    2.22871494F * stateEstimator_DW.IIR_IMUgyro_r_states[0];
  memIdx = 2;
  for (j = 0; j < 4; j++) {
    rtb_TrigonometricFunction_o2_idx_0 -= rtCP_IIR_IMUgyro_r_DenCoef[memIdx] *
      stateEstimator_DW.IIR_IMUgyro_r_states[j + 1];
    memIdx++;
  }

  stateEstimator_DW.IIR_IMUgyro_r_tmp = rtb_TrigonometricFunction_o2_idx_0 /
    1.0F;
  rtb_TrigonometricFunction_o2_idx_0 = 1.27253926F *
    stateEstimator_DW.IIR_IMUgyro_r_states[0] + 0.282124132F *
    stateEstimator_DW.IIR_IMUgyro_r_tmp;
  memIdx = 2;
  for (j = 0; j < 4; j++) {
    rtb_TrigonometricFunction_o2_idx_0 += rtCP_IIR_IMUgyro_r_NumCoef[memIdx] *
      stateEstimator_DW.IIR_IMUgyro_r_states[j + 1];
    memIdx++;
  }

  /* SignalConversion: '<S2>/TmpSignal ConversionAtProductInport2' incorporates:
   *  DiscreteFilter: '<S3>/IIR_IMUgyro_r'
   */
  rtb_TrigonometricFunction_o1_idx_0 = rtb_TrigonometricFunction_o2_idx_0;

  /* Product: '<S6>/Divide' incorporates:
   *  Product: '<S2>/Product'
   *  Reshape: '<S7>/Reshape (9) to [3x3] column-major'
   */
  for (j = 0; j < 3; j++) {
    rtb_VectorConcatenate_0[3 * j] = rtb_VectorConcatenate[3 * j] /
      rtb_TrigonometricFunction_o2_idx_1;
    rtb_VectorConcatenate_0[1 + 3 * j] = rtb_VectorConcatenate[3 * j + 1] /
      rtb_TrigonometricFunction_o2_idx_1;
    rtb_VectorConcatenate_0[2 + 3 * j] = rtb_VectorConcatenate[3 * j + 2] /
      rtb_TrigonometricFunction_o2_idx_1;
  }

  /* End of Product: '<S6>/Divide' */

  /* Product: '<S2>/Product' incorporates:
   *  DiscreteFilter: '<S3>/IIR_IMUgyro_r'
   *  SignalConversion: '<S2>/TmpSignal ConversionAtProductInport2'
   */
  for (j = 0; j < 3; j++) {
    rtb_Product[j] = rtb_VectorConcatenate_0[j + 6] *
      rtb_TrigonometricFunction_o2_idx_0 + (rtb_VectorConcatenate_0[j + 3] *
      stateEstimator_B.inverseIMU_gain[4] + rtb_VectorConcatenate_0[j] *
      stateEstimator_B.inverseIMU_gain[3]);
  }

  /* DiscreteFir: '<S3>/FIR_IMUaccel' */
  rtb_TrigonometricFunction_o2_idx_0 = stateEstimator_B.inverseIMU_gain[0] *
    0.0264077242F;
  memIdx = 1;
  for (j = stateEstimator_DW.FIR_IMUaccel_circBuf; j < 5; j++) {
    rtb_TrigonometricFunction_o2_idx_0 +=
      stateEstimator_DW.FIR_IMUaccel_states[j] *
      rtCP_FIR_IMUaccel_Coefficients[memIdx];
    memIdx++;
  }

  for (j = 0; j < stateEstimator_DW.FIR_IMUaccel_circBuf; j++) {
    rtb_TrigonometricFunction_o2_idx_0 +=
      stateEstimator_DW.FIR_IMUaccel_states[j] *
      rtCP_FIR_IMUaccel_Coefficients[memIdx];
    memIdx++;
  }

  rtb_FIR_IMUaccel_idx_0 = rtb_TrigonometricFunction_o2_idx_0;
  rtb_TrigonometricFunction_o2_idx_0 = stateEstimator_B.inverseIMU_gain[1] *
    0.0264077242F;
  memIdx = 1;
  for (j = stateEstimator_DW.FIR_IMUaccel_circBuf; j < 5; j++) {
    rtb_TrigonometricFunction_o2_idx_0 += stateEstimator_DW.FIR_IMUaccel_states
      [5 + j] * rtCP_FIR_IMUaccel_Coefficients[memIdx];
    memIdx++;
  }

  for (j = 0; j < stateEstimator_DW.FIR_IMUaccel_circBuf; j++) {
    rtb_TrigonometricFunction_o2_idx_0 += stateEstimator_DW.FIR_IMUaccel_states
      [5 + j] * rtCP_FIR_IMUaccel_Coefficients[memIdx];
    memIdx++;
  }

  rtb_TrigonometricFunction_o1_idx_1 = rtb_TrigonometricFunction_o2_idx_0;
  rtb_TrigonometricFunction_o2_idx_0 = stateEstimator_B.inverseIMU_gain[2] *
    0.0264077242F;
  memIdx = 1;
  for (j = stateEstimator_DW.FIR_IMUaccel_circBuf; j < 5; j++) {
    rtb_TrigonometricFunction_o2_idx_0 += stateEstimator_DW.FIR_IMUaccel_states
      [10 + j] * rtCP_FIR_IMUaccel_Coefficients[memIdx];
    memIdx++;
  }

  for (j = 0; j < stateEstimator_DW.FIR_IMUaccel_circBuf; j++) {
    rtb_TrigonometricFunction_o2_idx_0 += stateEstimator_DW.FIR_IMUaccel_states
      [10 + j] * rtCP_FIR_IMUaccel_Coefficients[memIdx];
    memIdx++;
  }

  /* Outputs for Atomic SubSystem: '<S2>/If Action Subsystem1' */
  /* DataTypeConversion: '<S2>/Data Type Conversion3' incorporates:
   *  Gain: '<S2>/Gain'
   *  Gain: '<S5>/Gain'
   *  Memory: '<S2>/Memory'
   *  SignalConversion: '<S6>/TmpSignal ConversionAtTrigonometric FunctionInport1'
   *  Sum: '<S2>/Sum'
   */
  rtb_TrigonometricFunction_o2_idx_1 = (0.005F * rtb_Product[0] +
    stateEstimator_DW.Memory_PreviousInput[0]) * 0.8F;

  /* End of Outputs for SubSystem: '<S2>/If Action Subsystem1' */

  /* Outputs for Atomic SubSystem: '<S2>/If Action Subsystem' */
  /* Gain: '<S4>/Gain2' */
  rtb_FIR_IMUaccel_idx_0 *= 0.101936802F;

  /* Trigonometry: '<S4>/Trigonometric Function1' */
  if (rtb_FIR_IMUaccel_idx_0 > 1.0F) {
    rtb_FIR_IMUaccel_idx_0 = 1.0F;
  } else {
    if (rtb_FIR_IMUaccel_idx_0 < -1.0F) {
      rtb_FIR_IMUaccel_idx_0 = -1.0F;
    }
  }

  /* DataTypeConversion: '<S2>/Data Type Conversion3' incorporates:
   *  DiscreteFir: '<S3>/FIR_IMUaccel'
   *  Gain: '<S2>/Gain'
   *  Gain: '<S4>/Gain'
   *  Gain: '<S4>/Gain1'
   *  Gain: '<S4>/Gain3'
   *  Gain: '<S4>/Gain4'
   *  Memory: '<S2>/Memory'
   *  Product: '<S4>/Divide'
   *  SignalConversion: '<S6>/TmpSignal ConversionAtTrigonometric FunctionInport1'
   *  Sum: '<S2>/Sum'
   *  Sum: '<S4>/Sum'
   *  Sum: '<S4>/Sum1'
   *  Trigonometry: '<S4>/Trigonometric Function'
   *  Trigonometry: '<S4>/Trigonometric Function1'
   */
  rtb_FIR_IMUaccel_idx_0 = (0.005F * rtb_Product[1] +
    stateEstimator_DW.Memory_PreviousInput[1]) * 0.999F + 0.001F * (real32_T)
    asin(rtb_FIR_IMUaccel_idx_0);
  rtb_TrigonometricFunction_o2_idx_0 = (0.005F * rtb_Product[2] +
    stateEstimator_DW.Memory_PreviousInput[2]) * 0.999F + (real32_T)atan
    (rtb_TrigonometricFunction_o1_idx_1 / rtb_TrigonometricFunction_o2_idx_0) *
    0.001F;

  /* End of Outputs for SubSystem: '<S2>/If Action Subsystem' */

  /* BusCreator: '<Root>/BusConversion_InsertedFor_states_estimout_at_inport_0' incorporates:
   *  DataTypeConversion: '<S2>/Data Type Conversion1'
   *  SignalConversion: '<S2>/TmpSignal ConversionAtProductInport2'
   */
  rty_states_estimout->yaw = rtb_TrigonometricFunction_o2_idx_1;
  rty_states_estimout->pitch = rtb_FIR_IMUaccel_idx_0;
  rty_states_estimout->roll = rtb_TrigonometricFunction_o2_idx_0;
  rty_states_estimout->p = stateEstimator_B.inverseIMU_gain[3];
  rty_states_estimout->q = stateEstimator_B.inverseIMU_gain[4];
  rty_states_estimout->r = rtb_TrigonometricFunction_o1_idx_0;

  /* Update for Memory: '<S2>/Memory' */
  stateEstimator_DW.Memory_PreviousInput[0] = rtb_TrigonometricFunction_o2_idx_1;
  stateEstimator_DW.Memory_PreviousInput[1] = rtb_FIR_IMUaccel_idx_0;
  stateEstimator_DW.Memory_PreviousInput[2] = rtb_TrigonometricFunction_o2_idx_0;

  /* Update for DiscreteFilter: '<S3>/IIR_IMUgyro_r' */
  stateEstimator_DW.IIR_IMUgyro_r_states[4] =
    stateEstimator_DW.IIR_IMUgyro_r_states[3];
  stateEstimator_DW.IIR_IMUgyro_r_states[3] =
    stateEstimator_DW.IIR_IMUgyro_r_states[2];
  stateEstimator_DW.IIR_IMUgyro_r_states[2] =
    stateEstimator_DW.IIR_IMUgyro_r_states[1];
  stateEstimator_DW.IIR_IMUgyro_r_states[1] =
    stateEstimator_DW.IIR_IMUgyro_r_states[0];
  stateEstimator_DW.IIR_IMUgyro_r_states[0] =
    stateEstimator_DW.IIR_IMUgyro_r_tmp;

  /* Update for DiscreteFir: '<S3>/FIR_IMUaccel' */
  /* Update circular buffer index */
  stateEstimator_DW.FIR_IMUaccel_circBuf--;
  if (stateEstimator_DW.FIR_IMUaccel_circBuf < 0) {
    stateEstimator_DW.FIR_IMUaccel_circBuf = 4;
  }

  /* Update circular buffer */
  stateEstimator_DW.FIR_IMUaccel_states[stateEstimator_DW.FIR_IMUaccel_circBuf] =
    stateEstimator_B.inverseIMU_gain[0];
  stateEstimator_DW.FIR_IMUaccel_states[stateEstimator_DW.FIR_IMUaccel_circBuf +
    5] = stateEstimator_B.inverseIMU_gain[1];
  stateEstimator_DW.FIR_IMUaccel_states[stateEstimator_DW.FIR_IMUaccel_circBuf +
    10] = stateEstimator_B.inverseIMU_gain[2];

  /* End of Update for DiscreteFir: '<S3>/FIR_IMUaccel' */
}

/* Model initialize function */
void stateEstimator_initialize(const char_T **rt_errorStatus)
{
  RT_MODEL_stateEstimator_T *const stateEstimator_M =
    &(stateEstimator_MdlrefDW.rtm);

  /* Registration code */

  /* initialize error status */
  rtmSetErrorStatusPointer(stateEstimator_M, rt_errorStatus);

  /* block I/O */
  (void) memset(((void *) &stateEstimator_B), 0,
                sizeof(B_stateEstimator_c_T));

  /* states (dwork) */
  (void) memset((void *)&stateEstimator_DW, 0,
                sizeof(DW_stateEstimator_f_T));
}
