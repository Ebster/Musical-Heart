//
//  HRMViewController.m
//  HeartMonitor
//
//  Created by Steven F. Daniel on 30/11/13.
//  Copyright (c) 2013 GENIESOFT STUDIOS. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()
{
    NSMutableArray *heartbeatArray;
    BOOL recordingHeartrate;
}

@end

@implementation PlayerViewController

@synthesize track;
@synthesize progressView;

-(void)updateTrack
{
    AppDelegate *delegater = [[UIApplication sharedApplication] delegate];
    recordingHeartrate = false;
    NSManagedObjectContext *context = [delegater managedObjectContext];
    progressView.progress = 0.0;
    track = (Tracks *)[context objectWithID:track.objectID];
    
    track.trackHeartrate = [NSNumber numberWithInt:[self getAverageHeartrate]];
    track.trackRecorded = [NSNumber numberWithBool:TRUE];
    
    
    NSError *error;
    [context save:&error];
}

#pragma mark - Music Player
- (IBAction)play{
    if(!theAudio.isPlaying){
        heartbeatArray = [[NSMutableArray alloc] init];
        [theAudio play];
        recordingHeartrate = TRUE;
    }
}

- (IBAction)stop{
    [theAudio stop];
    recordingHeartrate = FALSE;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Heartbeat Controller
- (void)rotateImage:(UIImageView *)image duration:(NSTimeInterval)duration curve:(int)curve degrees:(CGFloat)degrees
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform =
    CGAffineTransformMakeRotation(degrees);
    image.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //initailising variables---------
    recordingHeartrate = false;
    //---------
    
    
    
    self.polarH7DeviceData = nil;
    
    UIImage *backgroundimage = [[UIImage imageNamed:@"player_background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(300,300,0,300)];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundimage];
    
    
    [self.heartImage setImage:[UIImage imageNamed:@"_0016_push-button.png"]];
    [self.component setImage:[UIImage imageNamed:@"_0007_rec-area.png"]];
    [self.recorderLightRed setImage:[UIImage imageNamed:@"_0006_rec-red.png"]];
    [self.arrow setImage:[UIImage imageNamed:@"rec-arrow.png"]];
    self.arrow.layer.anchorPoint = CGPointMake(0.5f, 0.62f);
    [self rotateImage:self.arrow duration:3.0
                curve:UIViewAnimationCurveEaseInOut degrees:(M_PI/-3.00)];
    self.recorderLightRed.alpha = 0;
    [self.playerPlayStop setImage:[UIImage imageNamed:@"_0010_pause.png"]];
    UIImage *playerbackground = [[UIImage imageNamed:@"_0014_player-reflection.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(160,300,0,300)];
    
    self.player.image = playerbackground;
    
    //Set track for audio player
    NSString *path = [[NSBundle mainBundle] pathForResource:track.trackName ofType:@"mp3"];
    theAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
    
    
    //set player info
    [self.trackNameplaying setText: self.track.trackName];
    
    theAudio.delegate = self;
    
    // Clear out textView
    [self.deviceInfo setText:@""];
    [self.deviceInfo setTextColor:[UIColor blueColor]];
   
    [self.deviceInfo setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:25]];
    [self.deviceInfo setUserInteractionEnabled:NO];
    
    // Create our Heart Rate BPM Label
    self.heartRateBPM = [[UILabel alloc] initWithFrame:CGRectMake(35, 50, 200, 100)];
    // self.heartRateBPM = [[UILabel alloc] initWithFrame:CGRectMake(80, 60, 60, 80)];self.heartRateBPM.font = [UIFont fontWithName:@"Helvetica-Bold" size:70];
    
    [self.heartRateBPM setText:[NSString stringWithFormat:@"PUSH"]];
    self.heartRateBPM.font = [UIFont fontWithName:@"Helvetica-Bold" size:47];
    [self.heartRateBPM setTextColor: [UIColor colorWithRed:92.0/255.0 green:92.0/255.0 blue:88.0/255.0 alpha:0.9]];
  
    [self.heartImage addSubview:self.heartRateBPM];
    
    // Scan for all available CoreBluetooth LE devices
    //NSArray *services = @[[CBUUID UUIDWithString:POLARH7_HRM_HEART_RATE_SERVICE_UUID], [CBUUID UUIDWithString:POLARH7_HRM_DEVICE_INFO_SERVICE_UUID]];
    CBCentralManager *centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.centralManager = centralManager;
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [theAudio stop];
}

// method called whenever the device state changes.
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    // Determine the state of the peripheral
    if ([central state] == CBCentralManagerStatePoweredOff) {
        NSLog(@"CoreBluetooth BLE hardware is powered off");
    }
    else if ([central state] == CBCentralManagerStatePoweredOn) {
        NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
    }
    else if ([central state] == CBCentralManagerStateUnauthorized) {
        NSLog(@"CoreBluetooth BLE state is unauthorized");
    }
    else if ([central state] == CBCentralManagerStateUnknown) {
        NSLog(@"CoreBluetooth BLE state is unknown");
    }
    else if ([central state] == CBCentralManagerStateUnsupported) {
        NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
    }
}

- (IBAction)btnScan:(id)sender {
    
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}

// method called whenever we have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    self.connected = [NSString stringWithFormat:@"Connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
}

// CBPeripheralDelegate - Invoked when you discover the peripheral's available services.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

// CBCentralManagerDelegate - This is called with the CBPeripheral class as its main input parameter. This contains most of the information there is to know about a BLE peripheral.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    NSLog(@"Got device with name:%@", localName);
    if ([localName hasPrefix:@"Polar H7"]) {
        // We found the Heart Rate Monitor
        [self.centralManager stopScan];
        self.polarH7HRMPeripheral = peripheral;
        peripheral.delegate = self;
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

// Invoked when you discover the characteristics of a specified service.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ([service.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_HEART_RATE_SERVICE_UUID]])  {  // 1
        for (CBCharacteristic *aChar in service.characteristics)
        {
            // Request heart rate notifications
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_NOTIFICATIONS_SERVICE_UUID]]) { // 2
                [self.polarH7HRMPeripheral setNotifyValue:YES forCharacteristic:aChar];
            }
            // Request body sensor location
            else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_BODY_LOCATION_UUID]]) { // 3
                [self.polarH7HRMPeripheral readValueForCharacteristic:aChar];
            }
            //			else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_ENABLE_SERVICE_UUID]]) { // 4
            //				// Read the value of the heart rate sensor
            //				UInt8 value = 0x01;
            //				NSData *data = [NSData dataWithBytes:&value length:sizeof(value)];
            //				[peripheral writeValue:data forCharacteristic:aChar type:CBCharacteristicWriteWithResponse];
            //			}
        }
    }
    // Retrieve Device Information Services for the Manufacturer Name
    if ([service.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_DEVICE_INFO_SERVICE_UUID]])  { // 5
        for (CBCharacteristic *aChar in service.characteristics)
        {
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_MANUFACTURER_NAME_UUID]]) {
                [self.polarH7HRMPeripheral readValueForCharacteristic:aChar];
                NSLog(@"Found a Device Manufacturer Name Characteristic");
            }
        }
    }
}

// Invoked when you retrieve a specified characteristic's value, or when the peripheral device notifies your app that the characteristic's value has changed.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    // Updated value for heart rate measurement received
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_NOTIFICATIONS_SERVICE_UUID]]) { // 1
        // Get the Heart Rate Monitor BPM
        [self getHeartBPMData:characteristic error:error];
    }
    // Retrieve the characteristic value for manufacturer name received
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_MANUFACTURER_NAME_UUID]]) {  // 2
        [self getManufacturerName:characteristic];
    }
    // Retrieve the characteristic value for the body sensor location received
    else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_BODY_LOCATION_UUID]]) {  // 3
        [self getBodyLocation:characteristic];
    }
    
    // Add our constructed device information to our UITextView
    self.deviceInfo.text = [NSString stringWithFormat:@"%@\n%@\n%@\n", self.connected, self.bodyData, self.manufacturer];  // 4
}

// Instance method to get the heart rate BPM information
- (void) getHeartBPMData:(CBCharacteristic *)characteristic error:(NSError *)error
{
    // Get the Heart Rate Monitor BPM
    NSData *data = [characteristic value];      // 1
    const uint8_t *reportData = [data bytes];
    uint16_t bpm = 0;
    
    if ((reportData[0] & 0x01) == 0) {          // 2
        // Retrieve the BPM value for the Heart Rate Monitor
        bpm = reportData[1];
    }
    else {
        bpm = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[1]));  // 3
    }
    // Display the heart rate value to the UI if no error occurred
    if( (characteristic.value)  || !error ) {   // 4
        
        if(theAudio.isPlaying){
            self.recorderLightRed.alpha = 1;
            [self.playerPlayStop setImage:[UIImage imageNamed:@"_0011_play-icon.png"]];
            [heartbeatArray addObject:[NSNumber numberWithUnsignedInteger:bpm]]; //----adding all the heartbeats
            double som = (double)(theAudio.currentTime/theAudio.duration);
            progressView.progress = som;
            
            //setting up the time display
            NSTimeInterval timeleft = theAudio.duration - theAudio.currentTime;
            int min = timeleft/60;
            int sec = lroundf(timeleft)%60;
            self.trackTime.text = [NSString stringWithFormat:@"%d:%d", min,sec];
          
        }else if (recordingHeartrate)
        {
            self.trackTime.text = [NSString stringWithFormat:@"00:00"];
            [self updateTrack];
        }
        
        self.heartRate = bpm;
        if(theAudio.isPlaying)
        {
            [self rotateImage:self.arrow duration:1.0
                        curve:UIViewAnimationCurveEaseIn degrees:bpm/10];
            self.heartRateBPM.text = [NSString stringWithFormat:@"%i", bpm];
            [self.heartRateBPM setFrame:CGRectMake(75, 48, 200, 100)];
            
        
     
        [self doHeartBeat];
        self.pulseTimer = [NSTimer scheduledTimerWithTimeInterval:(60. / self.heartRate) target:self selector:@selector(doHeartBeat) userInfo:nil repeats:NO];
        }
    }
    return;
}

// Instance method to get the manufacturer name of the device
- (void) getManufacturerName:(CBCharacteristic *)characteristic
{
    NSString *manufacturerName = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    self.manufacturer = [NSString stringWithFormat:@"Manufacturer: %@", manufacturerName];
    return;
}

// Instance method to get the body location of the device
- (void) getBodyLocation:(CBCharacteristic *)characteristic
{
    NSData *sensorData = [characteristic value];
    uint8_t *bodyData = (uint8_t *)[sensorData bytes];
    if (bodyData ) {
        uint8_t bodyLocation = bodyData[0];
        self.bodyData = [NSString stringWithFormat:@"Body Location: %@", bodyLocation == 1 ? @"Chest" : @"Undefined"];
    }
    else {
        self.bodyData = [NSString stringWithFormat:@"Body Location: N/A"];
    }
    return;
}

// instance method to stop the device from rotating - only support the Portrait orientation


#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskPortrait;
}
// instance method to simulate our pulsating Heart Beat
- (void) doHeartBeat
{
    /*
    CALayer *layer = [self heartImage].layer;
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.toValue = [NSNumber numberWithFloat:1.1];
    pulseAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    
    pulseAnimation.duration = 60. / self.heartRate / 2.;
    pulseAnimation.repeatCount = 1;
    pulseAnimation.autoreverses = YES;
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [layer addAnimation:pulseAnimation forKey:@"scale"];
    
    self.pulseTimer = [NSTimer scheduledTimerWithTimeInterval:(60. / self.heartRate) target:self selector:@selector(doHeartBeat) userInfo:nil repeats:NO];
     */
    CALayer *layer = [self arrow].layer;
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotate"];
    rotateAnimation.toValue = [NSNumber numberWithFloat:1.1];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    
    rotateAnimation.duration = 60. / self.heartRate / 2.;
    rotateAnimation.repeatCount = 1;
    rotateAnimation.autoreverses = YES;
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [layer addAnimation:rotateAnimation forKey:@"rotate"];
    
    [NSTimer scheduledTimerWithTimeInterval:(60. / self.heartRate) target:self selector:@selector(doHeartBeat) userInfo:nil repeats:NO];
    /*
    
     */
}

// handle memory warning errors
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// retrieve average heartrate
- (int)getAverageHeartrate
{
    int total = 0;
    for (NSNumber* counter in heartbeatArray)
    {
        total = total + [counter intValue];
    }
    
    return total/heartbeatArray.count;
}


@end