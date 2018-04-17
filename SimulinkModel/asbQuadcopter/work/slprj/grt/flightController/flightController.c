/*
 * Code generation for system model 'flightController'
 *
 * Model                      : flightController
 * Model version              : 1.120
 * Simulink Coder version : 8.12 (R2017a) 16-Feb-2017
 * C source code generated on : Mon Apr 16 08:51:11 2018
 *
 * Note that the functions contained in this file are part of a Simulink
 * model, and are not self-contained algorithms.
 */

#include "flightController.h"
#include "flightController_private.h"

MdlrefDW_flightController_T flightController_MdlrefDW;

/* Block states (auto storage) */
DW_flightController_f_T flightController_DW;

/* System initialize for referenced model: 'flightController' */
void flightController_Init(void)
{
  /* InitializeConditions for Delay: '<S2>/Delay' */
  flightController_DW.Delay_DSTATE[0] = 0.0F;

  /* InitializeConditions for DiscreteIntegrator: '<S2>/Discrete-Time Integrator' */
  flightController_DW.DiscreteTimeIntegrator_DSTATE[0] = 0.0F;

  /* InitializeConditions for Delay: '<S2>/Delay' */
  flightController_DW.Delay_DSTATE[1] = 0.0F;

  /* InitializeConditions for DiscreteIntegrator: '<S2>/Discrete-Time Integrator' */
  flightController_DW.DiscreteTimeIntegrator_DSTATE[1] = 0.0F;
}

/* System reset for referenced model: 'flightController' */
void flightController_Reset(void)
{
  /* InitializeConditions for Delay: '<S2>/Delay' */
  flightController_DW.Delay_DSTATE[0] = 0.0F;

  /* InitializeConditions for DiscreteIntegrator: '<S2>/Discrete-Time Integrator' */
  flightController_DW.DiscreteTimeIntegrator_DSTATE[0] = 0.0F;

  /* InitializeConditions for Delay: '<S2>/Delay' */
  flightController_DW.Delay_DSTATE[1] = 0.0F;

  /* InitializeConditions for DiscreteIntegrator: '<S2>/Discrete-Time Integrator' */
  flightController_DW.DiscreteTimeIntegrator_DSTATE[1] = 0.0F;
}

/* Output and update for referenced model: 'flightController' */
void flightController(const CommandBus *rtu_ReferenceValueServerBus, const
                      statesEstim_t *rtu_states_estim, real32_T
                      rty_motors_refout[4])
{
  int32_T i;
  real32_T rtb_pitchrollerror_idx_0;
  real32_T rtb_pitchrollerror_idx_1;
  real32_T tmp;
  real32_T rtb_antiWU_Gain_idx_0;
  real32_T tmp_0;
  real32_T rtb_antiWU_Gain_idx_1;
  real32_T tmp_1;
  real32_T u0;

  /* Sum: '<S2>/Sum19' */
  rtb_pitchrollerror_idx_0 = rtu_ReferenceValueServerBus->orient_ref[1] -
    rtu_states_estim->pitch;
  rtb_pitchrollerror_idx_1 = rtu_ReferenceValueServerBus->orient_ref[2] -
    rtu_states_estim->roll;

  /* SignalConversion: '<S3>/TmpSignal ConversionAtProductInport2' incorporates:
   *  Gain: '<S4>/D_yaw'
   *  Gain: '<S4>/P_yaw'
   *  Sum: '<S4>/Sum1'
   *  Sum: '<S4>/Sum2'
   */
  tmp = (rtu_ReferenceValueServerBus->orient_ref[0] - rtu_states_estim->yaw) *
    0.004F - 0.0012F * rtu_states_estim->r;

  /* Gain: '<S2>/antiWU_Gain' incorporates:
   *  Delay: '<S2>/Delay'
   */
  rtb_antiWU_Gain_idx_0 = 0.001F * flightController_DW.Delay_DSTATE[0];

  /* SignalConversion: '<S3>/TmpSignal ConversionAtProductInport2' incorporates:
   *  DiscreteIntegrator: '<S2>/Discrete-Time Integrator'
   *  Gain: '<S2>/D_pr'
   *  Gain: '<S2>/I_pr'
   *  Gain: '<S2>/P_pr'
   *  Sum: '<S2>/Sum16'
   */
  tmp_0 = (0.013F * rtb_pitchrollerror_idx_0 + 0.01F *
           flightController_DW.DiscreteTimeIntegrator_DSTATE[0]) - 0.002F *
    rtu_states_estim->q;

  /* Gain: '<S2>/antiWU_Gain' incorporates:
   *  Delay: '<S2>/Delay'
   */
  rtb_antiWU_Gain_idx_1 = 0.001F * flightController_DW.Delay_DSTATE[1];

  /* SignalConversion: '<S3>/TmpSignal ConversionAtProductInport2' incorporates:
   *  DiscreteIntegrator: '<S2>/Discrete-Time Integrator'
   *  Gain: '<S2>/D_pr'
   *  Gain: '<S2>/I_pr'
   *  Gain: '<S2>/P_pr'
   *  Sum: '<S2>/Sum16'
   */
  tmp_1 = (0.02F * rtb_pitchrollerror_idx_1 + 0.01F *
           flightController_DW.DiscreteTimeIntegrator_DSTATE[1]) - 0.003F *
    rtu_states_estim->p;
  for (i = 0; i < 4; i++) {
    /* Product: '<S3>/Product' incorporates:
     *  Constant: '<S3>/TorquetotalThrustToThrustperMotor'
     *  Gain: '<S5>/thrustToMotorcommand'
     *  SignalConversion: '<S3>/TmpSignal ConversionAtProductInport2'
     */
    u0 = rtCP_TorquetotalThrustToThrustperMotor_Value[i + 12] * tmp_1 +
      (rtCP_TorquetotalThrustToThrustperMotor_Value[i + 8] * tmp_0 +
       (rtCP_TorquetotalThrustToThrustperMotor_Value[i + 4] * tmp +
        rtCP_TorquetotalThrustToThrustperMotor_Value[i] * 0.0F));

    /* Gain: '<S5>/Motordirections1' incorporates:
     *  Gain: '<S5>/thrustToMotorcommand'
     */
    u0 *= (-1530.72681F);
    if (u0 > 500.0F) {
      u0 = 500.0F;
    } else {
      if (u0 < 10.0F) {
        u0 = 10.0F;
      }
    }

    rty_motors_refout[i] = rtCP_Motordirections1_Gain[i] * u0;

    /* End of Gain: '<S5>/Motordirections1' */
  }

  /* Update for Delay: '<S2>/Delay' incorporates:
   *  DiscreteIntegrator: '<S2>/Discrete-Time Integrator'
   */
  flightController_DW.Delay_DSTATE[0] =
    flightController_DW.DiscreteTimeIntegrator_DSTATE[0];

  /* Update for DiscreteIntegrator: '<S2>/Discrete-Time Integrator' incorporates:
   *  Sum: '<S2>/Add'
   */
  flightController_DW.DiscreteTimeIntegrator_DSTATE[0] +=
    (rtb_pitchrollerror_idx_0 - rtb_antiWU_Gain_idx_0) * 0.005F;
  if (flightController_DW.DiscreteTimeIntegrator_DSTATE[0] >= 2.0F) {
    flightController_DW.DiscreteTimeIntegrator_DSTATE[0] = 2.0F;
  } else {
    if (flightController_DW.DiscreteTimeIntegrator_DSTATE[0] <= (-2.0F)) {
      flightController_DW.DiscreteTimeIntegrator_DSTATE[0] = (-2.0F);
    }
  }

  /* Update for Delay: '<S2>/Delay' incorporates:
   *  DiscreteIntegrator: '<S2>/Discrete-Time Integrator'
   */
  flightController_DW.Delay_DSTATE[1] =
    flightController_DW.DiscreteTimeIntegrator_DSTATE[1];

  /* Update for DiscreteIntegrator: '<S2>/Discrete-Time Integrator' incorporates:
   *  Sum: '<S2>/Add'
   */
  flightController_DW.DiscreteTimeIntegrator_DSTATE[1] +=
    (rtb_pitchrollerror_idx_1 - rtb_antiWU_Gain_idx_1) * 0.005F;
  if (flightController_DW.DiscreteTimeIntegrator_DSTATE[1] >= 2.0F) {
    flightController_DW.DiscreteTimeIntegrator_DSTATE[1] = 2.0F;
  } else {
    if (flightController_DW.DiscreteTimeIntegrator_DSTATE[1] <= (-2.0F)) {
      flightController_DW.DiscreteTimeIntegrator_DSTATE[1] = (-2.0F);
    }
  }
}

/* Model initialize function */
void flightController_initialize(const char_T **rt_errorStatus)
{
  RT_MODEL_flightController_T *const flightController_M =
    &(flightController_MdlrefDW.rtm);

  /* Registration code */

  /* initialize error status */
  rtmSetErrorStatusPointer(flightController_M, rt_errorStatus);

  /* states (dwork) */
  (void) memset((void *)&flightController_DW, 0,
                sizeof(DW_flightController_f_T));
}
