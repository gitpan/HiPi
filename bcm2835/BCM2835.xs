///////////////////////////////////////////////////////////////////////////////////////
// File          bcm2835/BCM2385.xs
// Description:  XS module for HiPi::BCM2385
// Created       Fri Nov 23 12:13:43 2012
// SVN Id        $Id:$
// Copyright:    Copyright (c) 2012 Mark Dootson
// Licence:      This work is free software; you can redistribute it and/or modify it 
//               under the terms of the GNU General Public License as published by the 
//               Free Software Foundation; either version 2 of the License, or any later 
//               version.
///////////////////////////////////////////////////////////////////////////////////////

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "../ppport.h"
#define BCM2835_NO_DELAY_COMPATIBILITY
#include "src/src/bcm2835.h"

MODULE = HiPi__BCM2835  PACKAGE = HiPi::BCM2835

#
# Init
#

int
bcm2835_init()

int
bcm2835_close()

void
bcm2835_set_debug(uint8_t debug)

#
# Low level register access
#

uint32_t 
bcm2835_peri_read(volatile uint32_t* paddr)

uint32_t 
bcm2835_peri_read_nb(volatile uint32_t* paddr)

void 
bcm2835_peri_write(volatile uint32_t* paddr, uint32_t value)

void 
bcm2835_peri_write_nb(volatile uint32_t* paddr, uint32_t value)

void 
bcm2835_peri_set_bits(volatile uint32_t* paddr, uint32_t value, uint32_t mask)

#
# GPIO register access
#

void 
bcm2835_gpio_fsel(uint8_t pin, uint8_t mode)

void 
bcm2835_gpio_set(uint8_t pin);

void 
bcm2835_gpio_clr(uint8_t pin)

void
bcm2835_gpio_set_multi(uint32_t mask)

void
bcm2835_gpio_clr_multi(uint32_t mask)

uint8_t 
bcm2835_gpio_lev(uint8_t pin)

uint8_t 
bcm2835_gpio_eds(uint8_t pin)

void 
bcm2835_gpio_set_eds(uint8_t pin)

void
bcm2835_gpio_ren(uint8_t pin)

void
bcm2835_gpio_clr_ren(uint8_t pin)

void
bcm2835_gpio_fen(uint8_t pin)

void
bcm2835_gpio_clr_fen(uint8_t pin)

void 
bcm2835_gpio_hen(uint8_t pin)

void 
bcm2835_gpio_clr_hen(uint8_t pin)

void 
bcm2835_gpio_len(uint8_t pin)

void 
bcm2835_gpio_clr_len(uint8_t pin)

void 
bcm2835_gpio_aren(uint8_t pin)

void 
bcm2835_gpio_clr_aren(uint8_t pin)

void 
bcm2835_gpio_afen(uint8_t pin)

void 
bcm2835_gpio_clr_afen(uint8_t pin)

void 
bcm2835_gpio_pud(uint8_t pud)

void 
bcm2835_gpio_pudclk(uint8_t pin, uint8_t on)

uint32_t 
bcm2835_gpio_pad(uint8_t group)

void 
bcm2835_gpio_set_pad(uint8_t group, uint32_t control)

void 
bcm2835_delay(unsigned int millis)

void
bcm2835_delayMicroseconds(unsigned int micros)

void
bcm2835_gpio_write(uint8_t pin, uint8_t on)

void
bcm2835_gpio_write_multi(uint32_t mask, uint8_t on)

void
bcm2835_gpio_write_mask(uint32_t value, uint32_t mask)

void
bcm2835_gpio_set_pud(uint8_t pin, uint8_t pud)

void 
bcm2835_spi_begin()

void 
bcm2835_spi_end()

void
bcm2835_spi_setBitOrder(uint8_t order)

void 
bcm2835_spi_setClockDivider(uint16_t divider)

void 
bcm2835_spi_setDataMode(uint8_t mode)

void 
bcm2835_spi_chipSelect(uint8_t cs)

void 
bcm2835_spi_setChipSelectPolarity(uint8_t cs, uint8_t active)

uint8_t 
bcm2835_spi_transfer(uint8_t value)

void 
bcm2835_spi_transfern(char *buf,  uint32_t len)

void
bcm2835_spi_transfernb(char *tbuf, char *rbuf, uint32_t len)

