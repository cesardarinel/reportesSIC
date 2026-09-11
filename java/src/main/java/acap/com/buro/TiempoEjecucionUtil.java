package acap.com.buro;

import java.util.logging.Level;
import java.util.logging.Logger;

public class TiempoEjecucionUtil {

    private TiempoEjecucionUtil() {}

    private static final Logger LOGGER = Logger.getLogger(TiempoEjecucionUtil.class.getName());

    public static void medirTiempo(String nombreOperacion, Runnable operacion) {
        long inicio = System.currentTimeMillis();
        operacion.run();
        long fin = System.currentTimeMillis();
        LOGGER.log(Level.INFO, "{0}: {1} s", new Object[]{nombreOperacion, (fin - inicio) / 1000.0});
    }
}
