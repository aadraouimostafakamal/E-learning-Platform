// middleware/errorHandler.js
const handleError = (err, req, res, next) => {
    if (!err) {
        err = new Error('An unknown error occurred');
    }
    // If res doesn't exist or was mutated, fallback gracefully
    if (!res || typeof res.status !== 'function') {
        console.error('Error: Response object is invalid', err);
        return;
    }

    const statusCode = err.status || 500;

    // Send the error response
    res.status(statusCode).json({ message: err.message || 'Internal Server Error' });
};

module.exports = handleError;
