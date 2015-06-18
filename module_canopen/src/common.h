
#ifndef __common_h__
#define __common_h__

#ifdef __canopen_conf_h_exists__
  #include "canopen_conf.h"
#endif


#ifndef CANOPEN_NODE_ID
  #define CANOPEN_NODE_ID 1
#endif

#ifndef HEARTBEAT_SUPPORTED
  #define HEARTBEAT_SUPPORTED 1
#endif

#ifndef CANOPEN_NUMBER_OF_TPDOS_SUPPORTED
  #define CANOPEN_NUMBER_OF_TPDOS_SUPPORTED 4
#endif

#ifndef CANOPEN_NUMBER_OF_RPDOS_SUPPORTED
  #define CANOPEN_NUMBER_OF_RPDOS_SUPPORTED 4
#endif

#ifndef CANOPEN_MAX_DATA_BUFFER_LENGTH
  #define CANOPEN_MAX_DATA_BUFFER_LENGTH 100
#endif

#define CANOPEN_BIT_TIME_TABLE_LENGTH 9

/**
* \enum obj_dictionary
* \brief objects in the object dictionary
*/
enum obj_dictionary
{
  PRE_DEFINED_ERROR_FIELD_OBJECT = 0x1003, /**<CANOpen predefined error field object */
  COB_ID_SYNC                    = 0x1005, /**<CANOpen SYNC COB-ID object */
  COMMUNICATION_CYCLE_PERIOD     = 0x1006, /**<CANOpen Communication Cycle period object */
  SYNC_WINDOW_LENGTH_OBJECT      = 0x1007, /**<CANOpen syn window length time object */
  GUARD_TIME_OBJECT              = 0x100C, /**<CANOpen guard time object */
  LIFE_TIME_FACTOR_OBJECT        = 0x100D, /**<CANOpen life time factor object */
  PRODUCER_HEARTBEAT_OBJECT      = 0x1017, /**<CANOpen producer heartbeat time object */
  IDENTITY_OBJECT                = 0x1018, /**<CANOpen Identity object */
  ERROR_BEHAVIOUR_OBJECT         = 0x1029, /**<CANOpen error behaviour object */
};

/**
* \enum access
* \brief access types of objects in the object dictionary
*/
enum access
{
  RO    = 0, /**<CANOpen Read only access to an object */
  WO    = 1, /**<CANOpen write only access to an object */
  RW    = 2, /**<CANOpen Read write only access to an object */
  RWR   = 3, /**<CANOpen RWR access to an object */
  RWW   = 4, /**<CANOpen RWW only access to an object */
  CONST = 5  /**<CANOpen CONSTANT in the object */
};

#endif /* common_h_ */
