# API Documentation

## To Test the Apis I have included postamn collection
  `  Tap-Despenser.postman_collection.json`


## localhost:3000/users `(POST)`
### user register body parameter example
```
   {
    "user":{
        "email": "attendee@example.com", 
        "password": "password",
        "role": "attendee"
        }                                       
    }
```

## localhost:3000/login `(POST)`
`Retrive Auth token for authentication purpose`
```
    {
        "email": "attendee@example.com", 
        "password": "password"
    }
```

## localhost:3000/dispensers `(GET)`
`Add Authorization ( Admin Bearer Token) in your Postman`

## localhost:3000/dispensers `(POST)`
### Creating new Dispenser
`Add Authorization (Admin Bearer Token) in your Postman`
`Add following in body as json`

```
{
  "dispenser": {
    "flow_volume": 0.5,
    "name": "abcd",
    "price_per_liter": 2
  }
}
```

## localhost:3000/dispensers/:id `(Get)`
### Get Dispenser Details
`Add Authorization (Bearer Token) in your Postman`
`Add following in body as json`

```
{
  "dispenser": {
    "flow_volume": 0.5,
    "name": "abcd",
    "price_per_liter": 2
  }
}
```


## localhost:3000/dispensers/:id (PATCH)
### open Dispenser
`Add Authorization (Bearer Token) in your Postman Authorization`
`Add following in body as json`

```
{
  "status": "open"
}
```
## localhost:3000/dispensers/:id (PATCH)
### Close Dispenser
`Add Authorization (Bearer Token) in your Postman Authorization`
`Add following in body as json`

```
{
  "status": "close"
}
```

## localhost:3000/dispensers/total_statistics `(GET)`
### Combined Event details for promoters
`Add Authorization (poromoter Bearer Token) in your Postman`