#########################################################################################
# Package       HiPi::Wiring
# Description:  Wrapper for wiringPi C library
# Created       Fri Nov 23 13:55:49 2012
# SVN Id        $Id: Wiring.pm 446 2013-02-01 02:55:27Z Mark Dootson $
# Copyright:    Copyright (c) 2012 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

package HiPi::Wiring;

#########################################################################################

=head1 NAME

HiPi::Wiring 

=head1 VERSION

Version 0.01

=head1 SYNOPSYS

    use HiPi::Wiring;
    use HiPi::Constant qw( :wiring );
    
    my $wi = HiPi::Wiring->new;
    
=head1 DESCRIPTION

This module is a thin wrapper around the excellent WiringPi library by
Gordon Henderson L<https://projects.drogon.net/raspberry-pi/wiringpi/>

The following constants are exported by HiPi::Constant under the :wiring
tag for use with HiPi::Wiring

    WPI_NUM_PINS
    WPI_MODE_PINS
    WPI_MODE_GPIO
    WPI_MODE_GPIO_SYS
    WPI_MODE_PIFACE
    WPI_INPUT 
    WPI_OUTPUT
    WPI_PWM_OUTPUT
    WPI_LOW
    WPI_HIGH
    WPI_PUD_OFF
    WPI_PUD_DOWN
    WPI_PUD_UP
    WPI_PWM_MODE_MS
    WPI_PWM_MODE_BAL
    WPI_NES_RIGHT
    WPI_NES_LEFT
    WPI_NES_DOWN
    WPI_NES_UP
    WPI_NES_START
    WPI_NES_SELECT
    WPI_NES_B
    WPI_NES_A

=head1 Wrapped Methods

    wiringPiSetup()
    wiringPiSetupSys()
    wiringPiSetupGpio()
    wiringPiSetupPiFace()
    piBoardRev()
    wpiPinToGpio(wpiPin)
    wpiPin()
    wiringPiSetupPiFaceForGpioProg()
    pinMode(pin, mode)
    pullUpDnControl(pin, pud)
    digitalWrite(pin, value)
    digitalWriteByte(value)
    pwmWrite(pin, value)
    setPadDrive(group, value)
    digitalRead(pin)
    delayMicroseconds(howLong)
    pwmSetMode(mode)
    pwmSetRange(range)
    pwmSetClock(divisor)
    waitForInterrupt(pin, mS)
    
    piLock(key)
    piUnlock(key)
    
    piHiPri(pri)
    
    delay(howLong)
    millis()
    
    gertboardAnalogWrite(chan, value)
    gertboardAnalogRead(chan)
    gertboardSPISetup()
    
    lcdHome(fd)
    lcdClear(fd)
    lcdPosition(fd, x, y)
    lcdPutchar(fd, data)
    lcdPuts(fd, putstring)
    lcdInit (rows, cols, bits, rs, strb, d0, d1, d2, d3, d4, d5, d6, d7)
    
    setupNesJoystick (dPin, cPin, lPin)
    readNesJoystick (joystick)
        
    softPwmCreate(pin, value, range)
    softPwmWrite(pin, value)
    
    softServoWrite(pin, value)
    softServoSetup(p0, p1, p2, p3, p4, p5, p6, p7)
    
    softToneCreate(pin)
    softToneWrite(pin, frewq)
 
    wiringPiI2CRead(fd)
    wiringPiI2CReadReg8(fd, reg)
    wiringPiI2CReadReg16(fd, reg)
    wiringPiI2CWrite(fd, data)
    wiringPiI2CWriteReg8(fd, reg, data)

    wiringPiI2CWriteReg16(fd, reg, data)
    wiringPiI2CSetup(devId)
 
    wiringPiSPIGetFd(channel)
    wiringPiSPIDataRW(channel, data, len)

    wiringPiSPISetup(channel, speed)
 
    serialOpen(device, baud)
    serialClose(fd)
    serialFlush(fd)
    serialPutchar(fd, c)
    serialPuts(fd, s)
    serialDataAvail(fd)
    serialGetchar(fd)
    
    shiftIn(dPin, cPin, order)
    shiftOut(dPin, cPin, order, val)

=head1 Methods not wrapped

  wiringPiISR(int pin, int mode, void (*function)(void))
  piThreadCreate (void *(*fn)(void *))

    Currently it would be better to implement your own threads and interrupt
    handling directly in Perl

  serialPrintf(int fd, char *message, ...)
  lcdPrintf(int fd, char *message, ...)

    Use sprintf to format strings in Perl before passing to wiringPi

    
=head1 LICENSE

This work is free software; you can redistribute it and/or modify it 
under the terms of the GNU General Public License as published by the 
Free Software Foundation; either version 3 of the License, or any later 
version.

=head3 License Note

I would normally release any Perl code under the Perl Artistic License
but this module wraps several GPL / LGPL C libraries and I feel that
the licensing of the entire distribution is simpler if the Perl code
is under GPL too.

=head1 AUTHOR

Mark Dootson, C<< <mdootson at cpan.org> >>

=head1 COPYRIGHT

Copyright (C) 2012-2013 Mark Dootson, all rights reserved.

=cut

use strict;
use warnings;
use Exporter;
use base qw( Exporter );
use XSLoader;

our $VERSION = '0.01';

unless($ENV{DEV_NONE_RASPBERRY_PLATFORM}) {
    # on real Raspberry Pi
    XSLoader::load('HiPi::Wiring', $VERSION);
}


1;



