/**
 * Gera o valor de temperatura com base no último valor de temperatura.
 * O novo valor a gerar será o incremento ao último valor gerado, adicionado de um valor
 * aleatório (positivo ou negativo).
 *
 * A componente aleatória não deverá produzir variações drásticas à temperatura entre medições consecutivas.
 *
 * @param ult_temp Último valor de temperatura medido (°C)
 * @param comp_rand Componente aleatório para a geração do novo valor da temperatura
 *
 * @return A nova medição do valor da temperatura (°C)
 */
char sens_temp(char ult_temp, char comp_rand);


/**
 * Gera o valor de velocidade do vento com base no último valor de velocidade do vento.
 * O novo valor a gerar será o incremento ao último valor gerado, adicionado de um valor
 * aleatório (positivo ou negativo).
 *
 * A componente aleatória pode produzir variações altas entre medições consecutivas, simulando assim o efeito
 * de rajadas de vento.
 *
 * @param ult_velc_vento Última velocidade do vento medida (km/h)
 * @param comp_rand Componente aleatório para a geração do novo valor da velocidade do vento
 *
 * @return O novo medição do valor da velocidade do vento (km/h)
 */
unsigned char sens_velc_vento(unsigned char ult_velc_vento, char comp_rand);


/**
 * Gera o valor de direção do vento com base no último valor de direção do vento.
 * O novo valor a gerar será o incremento ao último valor gerado, adicionado de um valor
 * aleatório (positivo ou negativo).
 *
 * A direção do vento toma valores de 0 a 359, representam graus relativamente ao Norte.
 *
 * A direção do vento não deve variar de forma drástica entre medições consecutivas.
 *
 * @param ult_dir_vento Última direção do vento medida (graus)
 * @param comp_rand Componente aleatório para a geração do novo valor da direção do vento
 *
 * @return A nova medição do valor da direção do vento (graus)
 */
unsigned short sens_dir_vento(unsigned short ult_dir_vento, short comp_rand);


/**
 * Gera o valor de humidade atmosférica com base no último valor de humidade atmosférica.
 * O novo valor a gerar será o incremento ao último valor gerado, adicionado de um valor
 * de modificação (positivo ou negativo).
 *
 * O valor de modificação terá uma componente aleatória e uma componente relativa ao último
 * valor de pluvisiodade registado, que contribuirá para uma maior ou menor alteração à
 * modificação.
 *
 * A menos que tenha chovido, o valor de modificação não deverá produzir variações drásticas à humidade
 * atmosférica entre medições consecutivas.
 *
 * @param ult_hmd_atm Última humidade atmosférica medida (percentagem)
 * @param ult_pluvio Último valor de pluviosidade medido (mm)
 * @param comp_rand Componente aleatório para a geração do novo valor da humidade atmosférica
 *
 * @return A nova medição do valor da humidade atmosférica (percentagem)
 */
unsigned char sens_humd_atm(unsigned char ult_hmd_atm, unsigned char ult_pluvio, char comp_rand);


/**
 * Gera o valor de humidade do solo com base no último valor de humidade do solo.
 * O novo valor a gerar será o incremento ao último valor gerado, adicionado de um valor
 * de modificação (positivo ou negativo).
 *
 * O valor de modificação terá uma componente aleatória e uma componente relativa ao último
 * valor de pluvisiodade registado, que contribuirá para uma maior ou menor alteração à
 * modificação.
 *
 * A menos que tenha chovido, o valor de modificação não deverá produzir variações drásticas à humidade do
 * solo entre medições consecutivas.
 *
 * @param ult_hmd_solo Última humidade do solo medida (percentagem)
 * @param ult_pluvio Último valor de pluviosidade medido (mm)
 * @param comp_rand Componente aleatório para a geração do novo valor da humidade do solo
 *
 * @return A nova medição do valor da humidade do solo (percentagem)
 */
unsigned char sens_humd_solo(unsigned char ult_hmd_solo, unsigned char ult_pluvio, char comp_rand);


/**
 * Gera o valor de pluviosidade com base no último valor de pluviosidade.
 * O novo valor a gerar será o incremento ao último valor gerado, adicionado de um valor
 * de modificação (positivo ou negativo).
 *
 * O valor de modificação terá uma componente aleatória e uma componente relativa à última
 * temperatura registada, que contribuirá para uma maior ou menor alteração à modificação.
 *
 * Assim produz-se o efeito de, com temperaturas altas ser menos provável que chova, e com
 * temperaturas mais baixas ser mais provável que chova.
 *
 * Quando a pluviosidade anterior for nula, se o valor de modificação for negativo a
 * pluviosidade deverá permanecer nula.
 *
 * @param ult_pluvio Último valor de pluviosidade medido (mm)
 * @param ult_temp Último valor de temperatura medido (°C)
 * @param comp_rand Componente aleatório para a geração do novo valor de pluviosidade
 *
 * @return A nova medição do valor de pluviosidade (mm)
 */
unsigned char sens_pluvio(unsigned char ult_pluvio, char ult_temp, char comp_rand);