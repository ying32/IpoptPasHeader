(*************************************************************************
   Copyright (C) 2004, 2010 International Business Machines and others.
   All Rights Reserved.
   This code is published under the Eclipse Public License.

   $Id$

   Authors:  Carl Laird, Andreas Waechter     IBM    2004-09-02
 *************************************************************************)
// https://github.com/coin-or/Ipopt/blob/master/Ipopt/src/Interfaces/IpStdCInterface.h
// 翻译ying32
unit IpStdCInterface;

{$Z4}

interface


type

  (** Type for all number.  We need to make sure that this is
      identical with what is defined in Common/IpTypes.hpp *)
  Number = Double;
  PNumber = ^Number;

  (** Type for all incides.  We need to make sure that this is
      identical with what is defined in Common/IpTypes.hpp *)
  //Index = Integer;
  //PIndex = ^Index;

  (** Type for all integers.  We need to make sure that this is
      identical with what is defined in Common/IpTypes.hpp *)
  //Int = Integer;

  (* This includes the SolverReturn enum type *)
//#include "IpReturnCodes.h"

 (** Return codes for the Optimize call for an application *)
 ApplicationReturnStatus = (
    Solve_Succeeded=0,
    Solved_To_Acceptable_Level=1,
    Infeasible_Problem_Detected=2,
    Search_Direction_Becomes_Too_Small=3,
    Diverging_Iterates=4,
    User_Requested_Stop=5,
    Feasible_Point_Found=6,

    Maximum_Iterations_Exceeded=-1,
    Restoration_Failed=-2,
    Error_In_Step_Computation=-3,
    Maximum_CpuTime_Exceeded=-4,
    Not_Enough_Degrees_Of_Freedom=-10,
    Invalid_Problem_Definition=-11,
    Invalid_Option=-12,
    Invalid_Number_Detected=-13,

    Unrecoverable_Exception=-100,
    NonIpopt_Exception_Thrown=-101,
    Insufficient_Memory=-102,
    Internal_Error=-199
  );

  (** enum to indicate the mode in which the algorithm is *)
   AlgorithmMode = (
    RegularMode=0,
    RestorationPhaseMode=1
    );


  (** Structure collecting all information about the problem
   *  definition and solve statistics etc.  This is defined in the
   *  source file. *)
  IpoptProblemInfo = record
  end;
  (** Pointer to a Ipopt Problem. *)
  IpoptProblem = ^IpoptProblemInfo;

  (** define a boolean type for C *)
  Bool = LongBool;

  (** A pointer for anything that is to be passed between the called
   *  and individual callback function *)
  UserDataPtr = Pointer;

  (** Type defining the callback function for evaluating the value of
   *  the objective function.  Return value should be set to false if
   *  there was a problem doing the evaluation. *)
  Eval_F_CB = function(n: Integer; x: PNumber; new_x: Bool; obj_value: PNumber; user_data: UserDataPtr): Bool; cdecl;

  (** Type defining the callback function for evaluating the gradient of
   *  the objective function.  Return value should be set to false if
   *  there was a problem doing the evaluation. *)
  Eval_Grad_F_CB = function(n: Integer; x: PNumber; new_x: Bool; grad_f: PNumber; user_data: UserDataPtr): Bool; cdecl;

  (** Type defining the callback function for evaluating the value of
   *  the constraint functions.  Return value should be set to false if
   *  there was a problem doing the evaluation. *)
   Eval_G_CB = function(n: Integer; x: PNumber; new_x: Bool; m: Integer; g: PNumber; user_data: UserDataPtr): Bool; cdecl;

  (** Type defining the callback function for evaluating the Jacobian of
   *  the constrant functions.  Return value should be set to false if
   *  there was a problem doing the evaluation. *)
  Eval_Jac_G_CB = function(n: Integer; x: PNumber; new_x: Bool; m, nele_jac: Integer; iRow, jCol: PInteger; values: PNumber; user_data: UserDataPtr): Bool; cdecl;

  (** Type defining the callback function for evaluating the Hessian of
   *  the Lagrangian function.  Return value should be set to false if
   *  there was a problem doing the evaluation. *)
  Eval_H_CB = function(n: Integer; x: PNumber; new_x: Bool; obj_factor: Number;
                       m: Integer; lambda: PNumber; new_lambda: Bool; nele_hess: Integer;
                       iRow, jCol: PInteger; values: PNumber; user_data: UserDataPtr): Bool; cdecl;

  (** Type defining the callback function for giving intermediate
   *  execution control to the user.  If set, it is called once per
   *  iteration, providing the user with some information on the state
   *  of the optimization.  This can be used to print some
   *  user-defined output.  It also gives the user a way to terminate
   *  the optimization prematurely.  If this method returns false,
   *  Ipopt will terminate the optimization. *)
   Intermediate_CB = function(alg_mod: Integer; (* 0 is regular, 1 is resto *)
                              iter_count: Integer;
                              obj_value, inf_pr, inf_du, mu, d_norm, regularization_size, alpha_du, alpha_pr: Number;
                              ls_trials: Integer;
                              user_data: UserDataPtr): Bool; cdecl;

  (** Function for creating a new Ipopt Problem object.  This function
   *  returns an object that can be passed to the IpoptSolve call.  It
   *  contains the basic definition of the optimization problem, such
   *  as number of variables and constraints, bounds on variables and
   *  constraints, information about the derivatives, and the callback
   *  function for the computation of the optimization problem
   *  functions and derivatives.  During this call, the options file
   *  PARAMS.DAT is read as well.
   *
   *  If NULL is returned, there was a problem with one of the inputs
   *  or reading the options file. *)
  //IPOPT_EXPORT(IpoptProblem) CreateIpoptProblem(
  function CreateIpoptProblem(
      n: Integer             (** Number of optimization variables *)
    ; x_L: PNumber         (** Lower bounds on variables. This array of
                              size n is copied internally, so that the
                              caller can change the incoming data after
                              return without that IpoptProblem is
                              modified.  Any value less or equal than
                              the number specified by option
                              'nlp_lower_bound_inf' is interpreted to
                              be minus infinity. *)
    ; x_U: Number          (** Upper bounds on variables. This array of
                              size n is copied internally, so that the
                              caller can change the incoming data after
                              return without that IpoptProblem is
                              modified.  Any value greater or equal
                              than the number specified by option
                              'nlp_upper_bound_inf' is interpreted to
                              be plus infinity. *)
    ; m: Integer              (** Number of constraints. *)
    ; g_L: PNumber          (** Lower bounds on constraints. This array of
                              size m is copied internally, so that the
                              caller can change the incoming data after
                              return without that IpoptProblem is
                              modified.  Any value less or equal than
                              the number specified by option
                              'nlp_lower_bound_inf' is interpreted to
                              be minus infinity. *)
    ; g_U: PNumber          (** Upper bounds on constraints. This array of
                              size m is copied internally, so that the
                              caller can change the incoming data after
                              return without that IpoptProblem is
                              modified.  Any value greater or equal
                              than the number specified by option
                              'nlp_upper_bound_inf' is interpreted to
                              be plus infinity. *)
    ; nele_jac: Integer       (** Number of non-zero elements in constraint
                              Jacobian. *)
    ; nele_hess: Integer      (** Number of non-zero elements in Hessian of
                              Lagrangian. *)
    ; index_style: Integer    (** indexing style for iRow & jCol,
				 0 for C style, 1 for Fortran style *)
    ; eval_f: Eval_F_CB     (** Callback function for evaluating
                              objective function *)
    ; eval_g: Eval_G_CB     (** Callback function for evaluating
                              constraint functions *)
    ; eval_grad_f: Eval_Grad_F_CB
                            (** Callback function for evaluating gradient
                              of objective function *)
    ; eval_jac_g: Eval_Jac_G_CB
                            (** Callback function for evaluating Jacobian
                              of constraint functions *)
    ; eval_h: Eval_H_CB     (** Callback function for evaluating Hessian
                              of Lagrangian function *)
  ): IpoptProblem; cdecl;

  (** Method for freeing a previously created IpoptProblem.  After
      freeing an IpoptProblem, it cannot be used anymore. *)
  procedure FreeIpoptProblem(ipopt_problem: IpoptProblem); cdecl;

  (** Function for adding a string option.  Returns FALSE the option
   *  could not be set (e.g., if keyword is unknown) *)
  function AddIpoptStrOption(ipopt_problem: IpoptProblem; keyword, val: PAnsiChar): Bool; cdecl;

  (** Function for adding a Number option.  Returns FALSE the option
   *  could not be set (e.g., if keyword is unknown) *)
  function AddIpoptNumOption(ipopt_problem: IpoptProblem; keyword: PAnsiChar; val: Number): Bool; cdecl;

  (** Function for adding an Int option.  Returns FALSE the option
   *  could not be set (e.g., if keyword is unknown) *)
  function AddIpoptIntOption(ipopt_problem: IpoptProblem; keyword: PAnsiChar; val: Integer): Bool; cdecl;

  (** Function for opening an output file for a given name with given
   *  printlevel.  Returns false, if there was a problem opening the
   *  file. *)
  function OpenIpoptOutputFile(ipopt_problem: IpoptProblem; file_name: PAnsiChar; print_level: Integer): Bool; cdecl;

  (** Optional function for setting scaling parameter for the NLP.
   *  This corresponds to the get_scaling_parameters method in TNLP.
   *  If the pointers x_scaling or g_scaling are NULL, then no scaling
   *  for x resp. g is done. *)
  function SetIpoptProblemScaling(ipopt_problem: IpoptProblem; obj_scaling: Number; x_scaling, g_scaling: PNumber): Bool; cdecl;

  (** Setting a callback function for the "intermediate callback"
   *  method in the TNLP.  This gives control back to the user once
   *  per iteration.  If set, it provides the user with some
   *  information on the state of the optimization.  This can be used
   *  to print some user-defined output.  It also gives the user a way
   *  to terminate the optimization prematurely.  If the callback
   *  method returns false, Ipopt will terminate the optimization.
   *  Calling this set method to set the CB pointer to NULL disables
   *  the intermediate callback functionality. *)
  function SetIntermediateCallback(ipopt_problem: IpoptProblem; intermediate_cb: Intermediate_CB): Bool; cdecl;

  (** Function calling the Ipopt optimization algorithm for a problem
      previously defined with CreateIpoptProblem.  The return
      specified outcome of the optimization procedure (e.g., success,
      failure etc).
   *)
  function IpoptSolve(
      ipopt_problem: IpoptProblem
                         (** Problem that is to be optimized.  Ipopt
                             will use the options previously specified with
                             AddIpoptOption (etc) for this problem. *)
    ; x: PNumber           (** Input:  Starting point
                             Output: Optimal solution *)
    ; g: PNumber           (** Values of constraint at final point
                             (output only - ignored if set to NULL) *)
    ; obj_val: PNumber     (** Final value of objective function
                             (output only - ignored if set to NULL) *)
    ; mult_g: PNumber      (** Input: Initial values for the constraint
                                    multipliers (only if warm start option
                                    is chosen)
                             Output: Final multipliers for constraints
                                     (ignored if set to NULL) *)
    ; mult_x_L: PNumber    (** Input: Initial values for the multipliers for
                                    lower variable bounds (only if warm start
                                    option is chosen)
                             Output: Final multipliers for lower variable
                                     bounds (ignored if set to NULL) *)
    ; mult_x_U: PNumber    (** Input: Initial values for the multipliers for
                                    upper variable bounds (only if warm start
                                    option is chosen)
                             Output: Final multipliers for upper variable
                                     bounds (ignored if set to NULL) *)
    ; user_data: UserDataPtr
                         (** Pointer to user data.  This will be
                             passed unmodified to the callback
                             functions. *)
  ): ApplicationReturnStatus; cdecl;


implementation

const
  // 需要跟据实际来写，我也不知道dll名是啥
  Ipoptdll = '';
  // 根据实际编译后的dll，函数有没有下划线来决定
  _U = '_';

function CreateIpoptProblem; external Ipoptdll name _U+ 'CreateIpoptProblem';
procedure FreeIpoptProblem; external Ipoptdll name _U+ 'FreeIpoptProblem';
function AddIpoptStrOption; external Ipoptdll name _U+ 'AddIpoptStrOption';
function AddIpoptNumOption; external Ipoptdll name _U+ 'AddIpoptNumOption';
function AddIpoptIntOption; external Ipoptdll name _U+ 'AddIpoptIntOption';
function OpenIpoptOutputFile; external Ipoptdll name _U+ 'OpenIpoptOutputFile';
function SetIpoptProblemScaling; external Ipoptdll name _U+ 'SetIpoptProblemScaling';
function SetIntermediateCallback; external Ipoptdll name _U+ 'SetIntermediateCallback';
function IpoptSolve; external Ipoptdll name _U+ 'IpoptSolve';

end.

