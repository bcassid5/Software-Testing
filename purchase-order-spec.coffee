describe 'PurchaseOrder', ->
  describe 'equivalance tests', ->
    describe '#AccountStatus', ->
      beforeEach ->
        spyOn(window, 'getAgeFactor').and.returnValue(1)
        spyOn(window, 'getBalanceFactor')

      method = AccountStatus
      classes =
        'invalid': -10,
        'poor': 400,
        'fair': 1500,
        'good': 6500,
        'very good': 12000

      it 'Function returns expected equivalance values', ->
        for key, value of classes
          getBalanceFactor.and.returnValue(value)
          expect(method(null)).toEqual(key)

    describe '#getAgeFactor', ->
      method = getAgeFactor
      classes = {
        '-1': -10,
        1: 0,
        5: 1,
        10: 3,
        20: 7,
        50: 50
      }

      it 'Function returns expected equivalance values', ->
        for key, value of classes
          account = { age: value }
          expect(method(account)).toEqual(parseInt(key))

    describe '#getBalanceFactor', ->
      method = getBalanceFactor
      classes = {
        '-1': -10,
        6: 0,
        16: 500,
        30: 5000,
        70: 75000,
        200: 200000,
        500: 2000000
      }

      it 'Function returns expected equivalance values', ->
        for key, value of classes
          account = { balance: value }
          expect(method(account)).toEqual(parseInt(key))

    describe '#creditStatus', ->
      method = creditStatus
      classes =
        'bad':
          'restricted': 500,
          'default': 500,
        'good':
          'restricted': 775,
          'default': 775
        'invalid':
          'restricted': 900,
          'default': 900

      it 'Function returns expected equivalance values', ->
        for creditType of classes
          for state, value of classes[creditType]
            account = { credit: value }
            expect(method(account, state)).toEqual(creditType)

    describe '#productStatus', ->
      method = productStatus
      storeThreshold = 50
      productName = 'headphones'

      classes =
        'sold-out': 0,
        'limited': storeThreshold - 10,
        'available': storeThreshold + 10,

      it 'Function returns expected equivalance values', ->
        for key, value of classes
          store = [{name: productName, q: value}]
          expect(method(productName, store, storeThreshold)).toEqual(key)

      it 'Function returns proper product', ->
        store = [{name: 'laptops', q: 12}]
        expect(method(productName, store, storeThreshold)).toEqual('sold-out')

    describe '#orderHandling', ->
      beforeEach ->
        spyOn(window, 'AccountStatus')
        spyOn(window, 'creditStatus')
        spyOn(window, 'productStatus')

      method = orderHandling
      classes =
        'accepted':
          accountStatus: 'very good'
        'pending':
          accountStatus: 'fair',
          creditStatus: 'good',
          productStatus: 'limited',
        'underReview':
          accountStatus: 'good',
          creditStatus: 'bad',
        'rejected':
          accountStatus: 'poor',
          creditStatus: 'bad',

      it 'Function returns expected equivalance values', ->
        for decision, obj of classes
          AccountStatus.and.returnValue(obj.accountStatus)
          creditStatus.and.returnValue(obj.creditStatus)
          productStatus.and.returnValue(obj.productStatus)

          expect(method()).toEqual(decision)

  describe 'boundary value tests', ->
    describe '#AccountStatus', ->
      beforeEach ->
        spyOn(window, 'getAgeFactor').and.returnValue(1)
        spyOn(window, 'getBalanceFactor')

      method = AccountStatus
      classes =
        'invalid': [-1]
        'poor': [0, 700]
        'fair': [701, 3000]
        'good': [3001, 10000]
        'very good': [100001]

      it 'Function returns expected boundary values', ->
        for key, values of classes
          for value in values
            getBalanceFactor.and.returnValue(value)
            expect(method(null)).toEqual(key)

    describe '#getAgeFactor', ->
      method = getAgeFactor
      classes = {
        '-1': [-1, 101],
        1: [0],
        5: [1],
        10: [2, 4],
        20: [5, 9],
        50: [10, 100]
      }

      it 'Function returns expected boundary values', ->
        for key, values of classes
          for value in values
            account = { age: value }
            expect(method(account)).toEqual(parseInt(key))

    describe '#getBalanceFactor', ->
      method = getBalanceFactor
      classes = {
        '-1': [-1],
        6: [0],
        16: [1, 1000],
        30: [1001, 50000],
        70: [50001, 100000],
        200: [100001, 1000000],
        500: [1000001]
      }

      it 'Function returns expected boundary values', ->
        for key, values of classes
          for value in values
            account = { balance: value }
            expect(method(account)).toEqual(parseInt(key))

    describe '#creditStatus', ->
      method = creditStatus
      classes =
        'bad':
          'restricted': [749]
          'default': [699]
        'good':
          'restricted': [750]
          'default': [700]
        'invalid':
          'either': [-1, 801, 500]

      it 'Function returns expected boundary values', ->
        for creditType of classes
          for key, values of classes[creditType]
            for value in values
              account = { credit: value }
              expect(method(account, key)).toEqual(creditType)

    describe '#productStatus', ->
      method = productStatus
      storeThreshold = 50
      productName = 'headphones'

      classes =
        'sold-out': [0]
        'limited': storeThreshold - 1
        'available': storeThreshold + 1

      it 'Function returns expected boundary values', ->
        for key, value of classes
          store = [{name: productName, q: value}]
          expect(method(productName, store, storeThreshold)).toEqual(key)

  describe 'decision table tests', ->
    describe '#orderHandling', ->
      beforeEach ->
        spyOn(window, 'AccountStatus')
        spyOn(window, 'creditStatus')
        spyOn(window, 'productStatus')

      method = orderHandling
      classes =
        accepted: [
          {
            accountStatus: 'very good'
          },
          {
            accountStatus: 'good'
            creditStatus: 'good'
          },
          {
            accountStatus: 'poor'
            creditStatus: 'good',
            productStatus: 'available'
          },
          {
            accountStatus: 'fair'
            creditStatus: 'good',
            productStatus: 'available'
          }
        ]
        pending: [
          {
            accountStatus: 'fair'
            creditStatus: 'good',
            productStatus: 'limited'
          },
          {
            accountStatus: 'fair'
            creditStatus: 'good',
            productStatus: 'sold-out'
          },
          {
            accountStatus: 'poor'
            creditStatus: 'good',
            productStatus: 'limited'
          }
        ]
        underReview: [
          {
            accountStatus: 'good'
            creditStatus: 'bad'
          },
          {
            accountStatus: 'fair'
            creditStatus: 'bad',
            productStatus: 'available'
          }
        ]
        rejected:[
          {
            accountStatus: 'fair'
            creditStatus: 'bad',
            productStatus: 'sold-out'
          },
          {
            accountStatus: 'fair'
            creditStatus: 'bad',
            productStatus: 'limited'
          },
          {
            accountStatus: 'poor'
            creditStatus: 'good',
            productStatus: 'sold-out'
          },
          {
            accountStatus: 'poor'
            creditStatus: 'bad'
          }
        ],
        invalid: [
          {
            accountStatus: 'invalid'
          },
          {
            creditStatus: 'invalid'
          },
          {
            productStatus: 'invalid'
          }
        ]

      it 'Function returns expected decision table values', ->
        for decision, sets of classes
          for set in sets
            AccountStatus.and.returnValue(set.accountStatus)
            creditStatus.and.returnValue(set.creditStatus)
            productStatus.and.returnValue(set.productStatus)

            expect(method()).toEqual(decision)
