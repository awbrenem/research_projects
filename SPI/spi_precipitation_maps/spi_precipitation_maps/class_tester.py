#Python class tester 


class Test: 


    def __init__(self, xvals, yvals) -> None:
        self.xbins = xvals
        self.ybins = yvals 
        self.area = xvals * yvals 

        return 
    
    def areasquared(self):
        return self.area ** 2 
    


if __name__ == '__main__':

    xv = 10 
    yv = 9
    m = Test(xv, yv)

    print(m.areasquared())
    print(m.xbins)
    m.attitude = "yes"
    print(m.attitude)


    