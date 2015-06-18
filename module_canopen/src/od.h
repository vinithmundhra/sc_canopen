
#ifndef __od_h__
#define __od_h__

/*==========================================================================*/
/**
* od_find_data_length is the function to find the data length from the
* object dictionary based on index and sub index.
*
* \param address index of the object dictionary entry
* \param sub_index subindex of object dictionary entry
* \return returns data length of the object
**/
int od_find_data_length(int address, unsigned char sub_index);

/*==========================================================================*/
/**
* od_find_index is the function to find the object position in the object
* dictionary structure based on the address.
*
* \param address index of the object dictionary entry
* \return index returns index position in the object dictionary
**/
int od_find_index(int address);

/*==========================================================================*/
/**
* od_read_data is the function in order to read data from
* object dictionary based on index, subindex and data length from the
* object dictionary.
*
* \param index index of the object dictionary entry
* \param od_sub_index subindex of the object dictionary entry
* \param data_buffer data buffer to store read data from object dictionary
* \param data_length length of data to be read from object dictionary
* \return none
**/
void od_read_data(int index,
                       unsigned char od_sub_index,
                       char data_buffer[],
                       unsigned char data_length);

/*==========================================================================*/
/**
* od_write_data is the function to write data to the
* object dictionary based on index, subindex and data length of the
* object dictionary entry.
*
* \param index index of the object dictionary entry
* \param od_sub_index subindex of the object dictionary entry
* \param data_buffer data buffer to write data to object dictionary
* \param data_length length of data to write data to object dictionary
* \return none
**/
void od_write_data(int index,
                      unsigned char od_sub_index,
                      char data_buffer[],
                      unsigned char data_length);

/*==========================================================================*/
/**
* od_find_access_of_index is the function to read the access type of
* an object from the object dictionary based on index and subindex from the
* object dictionary entry.
*
* \param index index of the object dictionary entry
* \param od_sub_index subindex of the object dictionary entry
* \return returns access type of object in the object dictionary
**/
unsigned char od_find_access_of_index(int index, unsigned char od_sub_index);


/*==========================================================================*/
/**
* od_find_no_of_si_entries is the function to read the no of sub-index of an
* object from the object dictionary based on index
*
* \param index index of the object dictionary entry
* \return returns no of subindexes for an object
**/
unsigned od_find_no_of_si_entries(int index);

#endif /* od_h_ */
